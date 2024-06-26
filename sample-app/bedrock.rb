require 'aws-sdk-bedrockruntime'
require "traceloop/sdk"

traceloop = Traceloop::SDK::Traceloop.new

model = "anthropic.claude-3-sonnet-20240229-v1:0"

traceloop.llm_call(provider="bedrock", model=model) do |tracer|
  tracer.log_prompt(user_prompt="Tell me a joke about OpenTelemetry")
  response = Aws::BedrockRuntime::Client.new.invoke_model({
      model_id: model,
      content_type: "application/json",
      accept: "*/*",
      body: {
        messages: [{ role: "user", content: "Tell me a joke about OpenTelemetry" }],
        max_tokens: 4096,
        anthropic_version: "bedrock-2023-05-31"
      }.to_json
    })
  tracer.log_response(response)

  body = JSON.parse(response.body.read())
  puts body
end
