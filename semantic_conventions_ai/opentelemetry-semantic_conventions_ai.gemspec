lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'opentelemetry-semantic_conventions_ai'
  spec.version     = '0.0.3'
  spec.authors     = ["Traceloop"]
  spec.email       = ['dev@traceloop.com']

  spec.summary     = 'OpenTelemetry Semantic Conventions Extension for Large Language Models'
  spec.description = 'OpenTelemetry Semantic Conventions Extension for Large Language Models'
  spec.homepage    = 'https://github.com/traceloop/openllmetry-ruby'
  spec.license     = 'Apache-2.0'

  spec.files = Dir.glob('lib/**/*.rb') +
               Dir.glob('*.md') +
               ['LICENSE']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'opentelemetry-api', '~> 1.0'

  if spec.respond_to?(:metadata)
    spec.metadata['source_code_uri'] = 'https://github.com/traceloop/openllmetry-ruby/tree/main/semantic_conventions'
    spec.metadata['bug_tracker_uri'] = 'https://github.com/traceloop/openllmetry-ruby/issues'
    spec.metadata['documentation_uri'] = "https://traceloop.com/docs/openllmetry"
  end
end
