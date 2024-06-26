
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require 'opentelemetry-semantic_conventions_ai'

module Traceloop
  module SDK
    class Traceloop
      def initialize
        OpenTelemetry::SDK.configure do |c|
          c.add_span_processor(
            OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
              OpenTelemetry::Exporter::OTLP::Exporter.new(
                endpoint: "#{ENV.fetch("TRACELOOP_BASE_URL", "https://api.traceloop.com")}/v1/traces",
                headers: { "Authorization" => "Bearer #{ENV.fetch("TRACELOOP_API_KEY")}" }
              )
            )
          )
          puts "Traceloop exporting traces to #{ENV.fetch("TRACELOOP_BASE", "https://api.traceloop.com")}"
        end

        @tracer = OpenTelemetry.tracer_provider.tracer("Traceloop")
      end

      class Tracer
        def initialize(span, provider, model)
          @span = span
          @provider = provider
          @model = model
        end

        def log_prompt(system_prompt="", user_prompt)
          unless system_prompt.empty?
            @span.add_attributes({
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.0.role" => "system",
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.0.content" => system_prompt,
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.1.role" => "user",
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.1.content" => user_prompt
            })
          else
            @span.add_attributes({
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.0.role" => "user",
              "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_PROMPTS}.0.content" => user_prompt
            })
          end
        end

        def log_response(response)
          if response.respond_to?(:body)
            log_bedrock_response(response)
          # This is Gemini specific, see -
          # https://github.com/gbaptista/gemini-ai?tab=readme-ov-file#generate_content
          elsif response.has_key?("candidates")
            log_gemini_response(response)
          else
            log_openai_response(response)
          end
        end

        def log_gemini_response(response)
          @span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_RESPONSE_MODEL => @model,
          })

          @span.add_attributes({
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.role" => "assistant",
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.content" => response.dig("candidates", 0, "content", "parts", 0, "text")
            })
        end

        def log_bedrock_response(response)
          body = JSON.parse(response.body.read())

          @span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_RESPONSE_MODEL => body.dig("model"),
          })
          if body.has_key?("usage")
            input_tokens = body.dig("usage", "input_tokens")
            output_tokens = body.dig("usage", "output_tokens")

            @span.add_attributes({
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_TOTAL_TOKENS => input_tokens + output_tokens,
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_COMPLETION_TOKENS => output_tokens,
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_PROMPT_TOKENS => input_tokens,
            })
          end
          if body.has_key?("content")
            @span.add_attributes({
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.role" => body.dig("role"),
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.content" => body.dig("content").first.dig("text")
            })
          end

          response.body.rewind()
        end

        def log_openai_response(response)
          @span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_RESPONSE_MODEL => response.dig("model"),
          })
          if response.has_key?("usage")
            @span.add_attributes({
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_TOTAL_TOKENS => response.dig("usage", "total_tokens"),
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_COMPLETION_TOKENS => response.dig("usage", "completion_tokens"),
              OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_USAGE_PROMPT_TOKENS => response.dig("usage", "prompt_tokens"),
            })
          end
          if response.has_key?("choices")
            @span.add_attributes({
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.role" => response.dig("choices", 0, "message", "role"),
            "#{OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_COMPLETIONS}.0.content" => response.dig("choices", 0, "message", "content")
            })
          end
        end
      end

      def llm_call(provider, model)
        @tracer.in_span("#{provider}.chat") do |span|
          span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::LLM_REQUEST_MODEL => model,
          })
          yield Tracer.new(span, provider, model)
        end
      end

      def workflow(name)
        @tracer.in_span("#{name}.workflow") do |span|
          span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_SPAN_KIND => "workflow",
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_ENTITY_NAME => name,
          })
          yield
        end
      end

      def task(name)
        @tracer.in_span("#{name}.task") do |span|
          span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_SPAN_KIND => "task",
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_ENTITY_NAME => name,
          })
          yield
        end
      end

      def agent(name)
        @tracer.in_span("#{name}.agent") do |span|
          span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_SPAN_KIND => "agent",
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_ENTITY_NAME => name,
          })
          yield
        end
      end

      def tool(name)
        @tracer.in_span("#{name}.tool") do |span|
          span.add_attributes({
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_SPAN_KIND => "tool",
            OpenTelemetry::SemanticConventionsAi::SpanAttributes::TRACELOOP_ENTITY_NAME => name,
          })
          yield
        end
      end
    end
  end
end
