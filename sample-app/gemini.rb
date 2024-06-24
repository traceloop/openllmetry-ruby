require 'gemini-ai'
require "traceloop/sdk"

client = Gemini.new(
  credentials: {
    service: 'vertex-ai-api',
    region: 'us-east4'
  },
  options: { model: 'gemini-pro', server_sent_events: true }
)

traceloop = Traceloop::SDK::Traceloop.new

traceloop.llm_call(provider="vertexai", model="gemini-pro") do |tracer|
  tracer.log_prompt(user_prompt="Tell me a joke about OpenTelemetry")
  response = client.generate_content(
    { contents: { role: "user", parts: { text: "Tell me a joke about OpenTelemetry" } } })
  tracer.log_response(response)
  puts response.dig("candidates", 0, "content")
end
