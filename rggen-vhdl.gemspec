# frozen_string_literal: true

require File.expand_path('lib/rggen/vhdl/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-vhdl'
  spec.version = RgGen::VHDL::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-vhdl-#{RgGen::VHDL::VERSION}"
  spec.description = 'VHDL writer plugin for RgGen'
  spec.homepage = 'https://github.com/rggen/rggen-vhdl'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1')

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rggen/rggen/issues',
    'mailing_list_uri' => 'https://groups.google.com/d/forum/rggen',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rggen/rggen-vhdl',
    'wiki_uri' => 'https://github.com/rggen/rggen/wiki'
  }

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rggen-systemverilog', '>= 0.34.0'
end
