# frozen_string_literal: true

require_relative 'lib/adjusted_cost_base/version'

Gem::Specification.new do |spec|
  spec.name = 'adjusted_cost_base'
  spec.version = AdjustedCostBase::VERSION
  spec.summary = 'CLI for calculating Adjusted Cost Base (ACB) and track capital gains.'
  spec.description = <<~DESC
    CLI for calculating Adjusted Cost Base (ACB) and track capital gains.
  DESC
  spec.authors = ['Scott Walkinshaw']

  spec.license = 'MIT'
  spec.email = 'scott.walkinshaw@gmail.com'
  spec.homepage = 'https://github.com/swalkinshaw/adjusted-cost-base'
  spec.metadata = {
    'bug_tracker_uri' => "https://github.com/swalkinshaw/adjusted_cost_base/issues",
    'homepage_uri' => spec.homepage,
    'source_code_uri' => "https://github.com/swalkinshaw/adjusted_cost_base"
  }

  spec.files = Dir['lib/**/*']
  spec.bindir = 'exe'
  spec.executables = %w[acb]
  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
end
