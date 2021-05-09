# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rof) do
  vhdl do
    main_code :bit_field, from_template: true
  end
end
