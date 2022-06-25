# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'support/shared_context'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
builder.plugin_manager.activate_plugin_by_name(:'rggen-default-register-map')

require 'rggen/systemverilog/rtl'
builder.plugin_manager.activate_plugin_by_name(:'rggen-sv-rtl')

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/vhdl'
builder.plugin_manager.activate_plugin_by_name(:'rggen-vhdl')

RGGEN_ROOT = ENV['RGGEN_ROOT'] || File.expand_path('../..', __dir__)
RGGEN_VHDL_ROOT = File.expand_path('..', __dir__)
RGGEN_SAMPLE_DIRECTORY = File.join(RGGEN_ROOT, 'rggen-sample')
