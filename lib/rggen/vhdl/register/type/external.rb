# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :external) do
  vhdl do
    build do
      generic :strobe_width, {
        name: "#{register.name}_STROBE_WIDTH".upcase,
        type: :positive, default: configuration.bus_width / 8
      }
      output :external_valid, {
        name: "o_#{register.name}_valid"
      }
      output :external_access, {
        name: "o_#{register.name}_access", width: 2
      }
      output :external_address, {
        name: "o_#{register.name}_address", width: address_width
      }
      output :external_write_data, {
        name: "o_#{register.name}_data", width: bus_width
      }
      output :external_strobe, {
        name: "o_#{register.name}_strobe", width: strobe_width
      }
      input :external_ready, {
        name: "i_#{register.name}_ready"
      }
      input :external_status, {
        name: "i_#{register.name}_status", width: 2
      }
      input :external_read_data, {
        name: "i_#{register.name}_data", width: bus_width
      }
    end

    main_code :register, from_template: true

    private

    def start_address
      hex(register.offset_address, address_width)
    end

    def byte_size
      register.total_byte_size
    end
  end
end
