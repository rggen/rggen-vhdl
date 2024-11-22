# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  vhdl do
    include RgGen::SystemVerilog::RTL::IndirectIndex

    build do
      signal :indirect_match, { width: index_match_width }
    end

    main_code :register do |code|
      indirect_index_matches(code)
      code << process_template
    end

    private

    def array_index_value(value, _width)
      value
    end

    def fixed_index_value(value, _width)
      value
    end

    def index_match_rhs(index)
      indirect_match[index]
    end

    def index_match_lhs(field, value)
      "'1' when unsigned(#{field}) = #{value} else '0'"
    end
  end
end
