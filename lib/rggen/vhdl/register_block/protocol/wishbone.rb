# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :wishbone) do
  vhdl do
    build do
      generic :use_stall, {
        name: 'USE_STALL', type: :boolean, default: true
      }

      input :wb_cyc, { name: 'i_wb_cyc' }
      input :wb_stb, { name: 'i_wb_stb' }
      output :wb_stall, { name: 'o_wb_stall' }
      input :wb_adr, { name: 'i_wb_adr', width: address_width }
      input :wb_we, { name: 'i_wb_we' }
      input :wb_dat_i, { name: 'i_wb_dat', width: bus_width }
      input :wb_sel, { name: 'i_wb_sel', width: bus_width / 8 }
      output :wb_ack, { name: 'o_wb_ack' }
      output :wb_err, { name: 'o_wb_err' }
      output :wb_rty, { name: 'o_wb_rty' }
      output :wb_dat_o, { name: 'o_wb_dat', width: bus_width }
    end

    main_code :register_block, from_template: true
  end
end
