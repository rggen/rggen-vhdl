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

    main_code :register_file do
      local_scope("g_#{register.name}") do |scope|
        scope.loop_size loop_size
        scope.signals signals
        scope.body(&method(:body_code))
      end
    end

    private

    def loop_size
      register.array? && local_loop_variables.zip(register.array_size) || nil
    end

    def signals
      register.declarations[:signal]
    end

    def body_code(code)
      register.generate_code(code, :register, :top_down)
    end
  end
end
