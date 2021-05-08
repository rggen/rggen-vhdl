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
        'vhdl/bit_field/type',
        'vhdl/bit_field/type/rc_w0c_w1c_wc_woc',
        'vhdl/bit_field/type/ro',
        'vhdl/bit_field/type/rw_w1_wo_wo1',
        'vhdl/bit_field/vhdl_top',
        'vhdl/register/vhdl_top',
        'vhdl/register_block/vhdl_top',
        'vhdl/register_file/vhdl_top'
      ]
    end
  end
end
