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
require_relative 'vhdl/register_map/keyword_checker'

RgGen.setup_plugin :'rggen-vhdl' do |plugin|
  plugin.version RgGen::VHDL::VERSION

  plugin.register_component :vhdl do
    component RgGen::VHDL::Component,
              RgGen::VHDL::ComponentFactory
    feature RgGen::VHDL::Feature,
            RgGen::VHDL::FeatureFactory
  end

  plugin.files [
    'vhdl/global/library_name',
    'vhdl/register_block/vhdl_top',
    'vhdl/register_block/protocol',
    'vhdl/register_block/protocol/apb',
    'vhdl/register_block/protocol/axi4lite',
    'vhdl/register_block/protocol/wishbone',
    'vhdl/register_file/vhdl_top',
    'vhdl/register/vhdl_top',
    'vhdl/register/type',
    'vhdl/register/type/external',
    'vhdl/register/type/indirect',
    'vhdl/register/type/rw',
    'vhdl/bit_field/vhdl_top',
    'vhdl/bit_field/type',
    'vhdl/bit_field/type/custom',
    'vhdl/bit_field/type/rc_w0c_w1c_wc_woc',
    'vhdl/bit_field/type/ro_rotrg',
    'vhdl/bit_field/type/rof',
    'vhdl/bit_field/type/rohw',
    'vhdl/bit_field/type/row0trg_row1trg',
    'vhdl/bit_field/type/rowo_rowotrg',
    'vhdl/bit_field/type/rs_w0s_w1s_ws_wos',
    'vhdl/bit_field/type/rw_rwtrg_w1',
    'vhdl/bit_field/type/rwc',
    'vhdl/bit_field/type/rwe_rwl',
    'vhdl/bit_field/type/rwhw',
    'vhdl/bit_field/type/rws',
    'vhdl/bit_field/type/w0crs_w0src_w1crs_w1src_wcrs_wsrc',
    'vhdl/bit_field/type/w0t_w1t',
    'vhdl/bit_field/type/w0trg_w1trg',
    'vhdl/bit_field/type/wo_wo1_wotrg',
    'vhdl/bit_field/type/wrc_wrs'
  ]

  plugin.files [
    'vhdl/register_map/name'
  ]
end
