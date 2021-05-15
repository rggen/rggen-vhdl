# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :vhdl_top) do
  vhdl do
    include RgGen::SystemVerilog::RTL::BitFieldIndex

    export :initial_value
    export :value

    build do
      if parameterized_initial_value?
        generic :initial_value, {
          name: initial_value_name, width: initial_value_width,
          default: default_initial_value
        }
      else
        define_accessor_for_initial_value
      end
    end

    main_code :register do
      local_scope("g_#{bit_field.name}") do |scope|
        scope.loop_size loop_size
        scope.body(&method(:body_code))
      end
    end

    def value(offsets = nil, width = nil)
      value_lsb = bit_field.lsb(offsets&.last || local_index)
      value_width = width || bit_field.width
      register_value(offsets&.slice(0..-2), value_lsb, value_width)
    end

    private

    def parameterized_initial_value?
      bit_field.initial_value? && !bit_field.fixed_initial_value?
    end

    def initial_value_name
      "#{bit_field.full_name('_')}_initial_value".upcase
    end

    def initial_value_width
      width = bit_field.width
      repeat_size = bit_field.sequence_size || 1
      width * repeat_size
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

    def register_value(offsets, lsb, width)
      index = register.index(offsets || register.local_indices)
      register_block.register_value[[index], lsb, width]
    end

    def loop_size
      loop_variable = local_index
      loop_variable && { loop_variable => bit_field.sequence_size }
    end

    def body_code(code)
      bit_field.generate_code(code, :bit_field, :top_down)
    end
  end
end
