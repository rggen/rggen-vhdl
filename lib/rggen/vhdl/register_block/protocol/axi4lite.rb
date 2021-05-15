# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :axi4lite) do
  vhdl do
    build do
      generic :id_width, { name: 'ID_WIDTH', type: :natural, default: 0 }
      generic :write_first, { name: 'WRITE_FIRST', type: :boolean, default: true }

      input :awvalid, { name: 'i_awvalid' }
      output :awready, { name: 'o_awready' }
      input :awid, { name: 'i_awid', width: id_width_value }
      input :awaddr, { name: 'i_awaddr', width: address_width }
      input :awprot, { name: 'i_awprot', width: 3 }
      input :wvalid, { name: 'i_wvalid' }
      output :wready, { name: 'o_wready' }
      input :wdata, { name: 'i_wdata', width: bus_width }
      input :wstrb, { name: 'i_wstrb', width: bus_width / 8 }
      output :bvalid, { name: 'o_bvalid' }
      input :bready, { name: 'i_bready' }
      output :bid, { name: 'o_bid', width: id_width_value }
      output :bresp, { name: 'o_bresp', width: 2 }
      input :arvalid, { name: 'i_arvalid' }
      output :arready, { name: 'o_arready' }
      input :arid, { name: 'i_arid', width: id_width_value }
      input :araddr, { name: 'i_araddr', width: address_width }
      input :arprot, { name: 'i_arprot', width: 3 }
      output :rvalid, { name: 'o_rvalid' }
      input :rready, { name: 'i_rready' }
      output :rid, { name: 'o_rid', width: id_width_value }
      output :rdata, { name: 'o_rdata', width: bus_width }
      output :rresp, { name: 'o_rresp', width: 2 }
    end

    main_code :register_block, from_template: true

    private

    def id_width_value
      "clip_id_width(#{id_width})"
    end
  end
end
