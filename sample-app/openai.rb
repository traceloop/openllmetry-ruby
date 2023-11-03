require "openai"
require "traceloop/sdk"

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_API_KEY")
end

client = OpenAI::Client.new

traceloop = Traceloop::SDK::Traceloop.new

traceloop.llm_call() do |tracer|
  tracer.log_prompt(model="gpt-3.5-turbo", user_prompt="Tell me a joke about OpenTelemetry")
  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "Tell me a joke about OpenTelemetry" }]
    })
  tracer.log_response(response)
  puts response.dig("choices", 0, "message", "content")
end
