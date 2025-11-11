module OpenTelemetry
  module SemanticConventionsAi
    module SpanAttributes
      # LLM
      LLM_VENDOR = "llm.vendor"
      LLM_REQUEST_TYPE = "llm.request.type"
      LLM_REQUEST_MODEL = "llm.request.model"
      LLM_RESPONSE_MODEL = "llm.response.model"
      LLM_REQUEST_MAX_TOKENS = "llm.request.max_tokens"
      LLM_USAGE_TOTAL_TOKENS = "llm.usage.total_tokens"
      LLM_USAGE_COMPLETION_TOKENS = "llm.usage.completion_tokens"
      LLM_USAGE_PROMPT_TOKENS = "llm.usage.prompt_tokens"
      LLM_TEMPERATURE = "llm.temperature"
      LLM_TOP_P = "llm.top_p"
      LLM_FREQUENCY_PENALTY = "llm.frequency_penalty"
      LLM_PRESENCE_PENALTY = "llm.presence_penalty"
      LLM_PROMPTS = "llm.prompts"
      LLM_COMPLETIONS = "llm.completions"
      LLM_CHAT_STOP_SEQUENCES = "llm.chat.stop_sequences"

      # Vector DB
      VECTOR_DB_VENDOR = "vector_db.vendor"
      VECTOR_DB_QUERY_TOP_K = "vector_db.query.top_k"

      # LLM Workflows
      TRACELOOP_SPAN_KIND = "traceloop.span.kind"
      TRACELOOP_WORKFLOW_NAME = "traceloop.workflow.name"
      TRACELOOP_ENTITY_NAME = "traceloop.entity.name"
      TRACELOOP_ASSOCIATION_PROPERTIES = "traceloop.association.properties"

      # Deprecated
      TRACELOOP_CORRELATION_ID = "traceloop.correlation.id"

      # Gen AI
      GEN_AI_REQUEST_MODEL = "gen_ai.request.model"
      GEN_AI_RESPONSE_MODEL = "gen_ai.response.model"
      GEN_AI_USAGE_COMPLETION_TOKENS = "gen_ai.usage.completion_tokens"
      GEN_AI_USAGE_PROMPT_TOKENS = "gen_ai.usage.prompt_tokens"
      GEN_AI_COMPLETIONS = "gen_ai.completion"
      GEN_AI_PROMPTS = "gen_ai.prompt"
      GEN_AI_SYSTEM = "gen_ai.system"
    end

    module LLMRequestTypeValues
        COMPLETION = "completion"
        CHAT = "chat"
        RERANK = "rerank"
        UNKNOWN = "unknown"
    end

    module TraceloopSpanKindValues
        WORKFLOW = "workflow"
        TASK = "task"
        AGENT = "agent"
        TOOL = "tool"
        UNKNOWN = "unknown"
    end
  end
end
