# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :vhdl_top) do
  vhdl do
    build do
      input :clock, { name: 'i_clk' }
      input :reset, { name: 'i_rst_n' }

      signal :register_valid
      signal :register_access, {
        width: 2
      }
      signal :register_address, {
        width: address_width
      }
      signal :register_write_data, {
        width: bus_width
      }
      signal :register_strobe, {
        width: bus_width
      }
      signal :register_active, {
        array_size: [total_registers]
      }
      signal :register_ready, {
        array_size: [total_registers]
      }
      signal :register_status, {
        width: 2, array_size: [total_registers]
      }
      signal :register_read_data, {
        width: bus_width, array_size: [total_registers]
      }
      signal :register_value, {
        width: value_width, array_size: [total_registers]
      }
    end

    write_file '<%= register_block.name %>.vhd' do |file|
      file.body { process_template }
    end

    private

    def total_registers
      register_block.files_and_registers.sum(&:count)
    end

    def address_width
      register_block.local_address_width
    end

    def bus_width
      configuration.bus_width
    end

    def value_width
      register_block.registers.map(&:width).max
    end

    def generic_declarations
      register_block
        .declarations[:generic]
        .then(&method(:add_terminator))
    end

    def port_declarations
      register_block
        .declarations[:port]
        .then(&method(:sort_port_declarations))
        .then(&method(:add_terminator))
    end

    def signal_declarations
      register_block.declarations[:signal]
    end

    def architecture_body_code
      code_block(2) do |code|
        register_block.generate_code(code, :register_block, :top_down)
        register_block.generate_code(code, :register_file, :top_down, 1)
      end
    end

    def sort_port_declarations(declarations)
      declarations
        .partition(&method(:clock_or_reset?))
        .flatten
    end

    def clock_or_reset?(declaration)
      [clock.to_s, reset.to_s]
        .any? { |port_name| declaration.include?(port_name) }
    end

    def add_terminator(declarations)
      declarations.map.with_index do |declaration, i|
        (i == declarations.size - 1) && declaration ||
          declaration + semicolon
      end
    end
  end
end
