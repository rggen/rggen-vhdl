# frozen_string_literal: true

require 'rggen/systemverilog'
require_relative 'vhdl/version'
require_relative 'vhdl/utility/identifier'
require_relative 'vhdl/utility/data_object'
require_relative 'vhdl/utility/local_scope'
require_relative 'vhdl/utility'
require_relative 'vhdl/component'
require_relative 'vhdl/feature'
require_relative 'vhdl/factories'

module RgGen
  module VHDL
    extend Core::Plugin

    setup_plugin :'rggen-vhdl' do |plugin|
      plugin.register_component :vhdl do
        component Component, ComponentFactory
        feature Feature, FeatureFactory
      end

      plugin.files [
        'vhdl/register/vhdl_top',
        'vhdl/register_block/vhdl_top'
      ]
    end
  end
end
