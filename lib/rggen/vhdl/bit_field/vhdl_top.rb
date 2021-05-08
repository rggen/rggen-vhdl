# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :vhdl_top) do
  vhdl do
    include RgGen::SystemVerilog::RTL::BitFieldIndex

    export :initial_value

    build do
      if parameterized_initial_value?
        generic :initial_value, {
          name: initial_value_name, default: default_initial_value
        }
      else
        define_accessor_for_initial_value
      end
    end

    private

    def parameterized_initial_value?
      bit_field.initial_value? && !bit_field.fixed_initial_value?
    end

    def initial_value_name
      "#{bit_field.full_name('_')}_initial_value".upcase
    end

    def default_initial_value
      width = bit_field.width
      repeat_size = bit_field.sequence_size || 1
      value = initial_value_rhs_default
      "repeat(#{value}, #{width}, #{repeat_size})"
    end

    def define_accessor_for_initial_value
      define_singleton_method(:initial_value) do
        if bit_field.initial_value_array?
          array_initial_value_rhs
        elsif bit_field.initial_value?
          initial_value_rhs_default
        end
      end
    end

    def initial_value_rhs_default
      hex(bit_field.register_map.initial_value, bit_field.width)
    end

    def array_initial_value_rhs
      value =
        bit_field.initial_values
          .map.with_index { |v, i| v << bit_field.width * i }
          .inject(:|)
      hex(value, bit_field.sequence_size * bit_field.width)
    end
  end
end
