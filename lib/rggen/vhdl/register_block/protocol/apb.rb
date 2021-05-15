# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :apb) do
  vhdl do
    build do
      input :psel, { name: 'i_psel' }
      input :penable, { name: 'i_penable' }
      input :paddr, { name: 'i_paddr', width: address_width }
      input :pprot, { name: 'i_pprot', width: 3 }
      input :pwrite, { name: 'i_pwrite' }
      input :pstrb, { name: 'i_pstrb', width: bus_width / 8 }
      input :pwdata, { name: 'i_pwdata', width: bus_width }
      output :pready, { name: 'o_pready' }
      output :prdata, { name: 'o_prdata', width: bus_width }
      output :pslverr, { name: 'o_pslverr' }
    end

    main_code :register_block, from_template: true
  end
end
