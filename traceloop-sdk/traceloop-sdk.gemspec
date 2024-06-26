Gem::Specification.new do |spec|
  spec.name        = 'traceloop-sdk'
  spec.version     = '0.0.8'
  spec.authors     = ["Traceloop"]
  spec.email       = ['dev@traceloop.com']

  spec.summary     = 'Traceloop Software Development Kit (SDK) for Ruby'
  spec.description = 'Traceloop Software Development Kit (SDK) for Ruby'
  spec.homepage    = 'https://github.com/traceloop/openllmetry-ruby'
  spec.license     = 'Apache-2.0'

  spec.files = Dir.glob('lib/**/*.rb') +
               Dir.glob('*.md') +
               ['LICENSE']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'opentelemetry-semantic_conventions_ai', '~> 0.0.3'

  spec.add_dependency 'opentelemetry-sdk', '~> 1.3.1'
  spec.add_dependency 'opentelemetry-exporter-otlp', '~> 0.26.1'

  if spec.respond_to?(:metadata)
    spec.metadata['source_code_uri'] = 'https://github.com/traceloop/openllmetry-ruby/tree/main/traceloop-sdk'
    spec.metadata['bug_tracker_uri'] = 'https://github.com/traceloop/openllmetry-ruby/issues'
    spec.metadata['documentation_uri'] = "https://traceloop.com/docs/openllmetry"
  end
end
