# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  vhdl do
    build do
      signal :indirect_match, { width: match_width }
    end

    main_code :register, from_template: true

    private

    def match_width
      register.index_entries.size
    end

    def index_fields
      register
        .collect_index_fields(register_block.bit_fields)
        .map(&:value)
    end

    def index_values
      loop_variables = register.local_loop_variables
      register.index_entries.map do |entry|
        entry.array_index? && loop_variables.shift || entry.value
      end
    end

    def index_fields_and_values
      index_fields.zip(index_values)
    end
  end
end
