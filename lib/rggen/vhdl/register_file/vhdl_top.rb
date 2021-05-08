# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :vhdl_top) do
  vhdl do
    include RgGen::SystemVerilog::RTL::RegisterIndex
  end
end
