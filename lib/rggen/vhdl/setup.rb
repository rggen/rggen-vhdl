# frozen_string_literal: true

require 'rggen/vhdl'

RgGen.register_plugin RgGen::VHDL do |builder|
  builder.load_plugin 'rggen/systemverilog/rtl/setup'
  builder.enable :register_block, [:vhdl_top]
  builder.enable :register_file, [:vhdl_top]
  builder.enable :register, [:vhdl_top]
  builder.enable :bit_field, [:vhdl_top]
end
