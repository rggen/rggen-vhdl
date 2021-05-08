# frozen_string_literal: true

RgGen.define_simple_feature(:register, :vhdl_top) do
  vhdl do
    include RgGen::SystemVerilog::RTL::RegisterIndex

    build do
      unless register.bit_fields.empty?
        signal :bit_field_valid
        signal :bit_field_read_mask, width: register.width
        signal :bit_field_write_mask, width: register.width
        signal :bit_field_write_data, width: register.width
        signal :bit_field_read_data, width: register.width
        signal :bit_field_value, width: register.width
      end
    end
  end
end
