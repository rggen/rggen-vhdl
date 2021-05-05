# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'support/shared_context'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.plugin_spec.activate(builder)

require 'rggen/systemverilog/rtl'
RgGen::SystemVerilog::RTL.plugin_spec.activate(builder)

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/vhdl'
RgGen::VHDL.plugin_spec.activate(builder)
