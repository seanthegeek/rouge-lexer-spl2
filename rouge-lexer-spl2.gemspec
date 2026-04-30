# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rouge-lexer-spl2'
  s.version     = '0.2.0'
  s.summary     = 'Rouge lexer for Splunk SPL2'
  s.description = 'A Rouge plugin providing syntax highlighting for Splunk SPL2, the search processing language used by Splunk Cloud Platform.'
  s.authors     = ['Sean Whalen']
  s.homepage    = 'https://github.com/seanthegeek/rouge-lexer-spl2'
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*.rb'] + Dir['spec/demos/*'] + Dir['spec/visual/samples/*'] + ['README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'rouge', '>= 3.0'

  s.metadata = {
    'source_code_uri'   => 'https://github.com/seanthegeek/rouge-lexer-spl2',
    'bug_tracker_uri'   => 'https://github.com/seanthegeek/rouge-lexer-spl2/issues',
    'changelog_uri'     => 'https://github.com/seanthegeek/rouge-lexer-spl2/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/seanthegeek/rouge-lexer-spl2/blob/main/README.md'
  }
end
