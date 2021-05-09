# frozen_string_literal: true

RSpec.describe 'bit_field/type/rof' do
  include_context 'clean-up builder'
  include_context 'vhdl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:rof])
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  def create_bit_fields(&body)
    create_vhdl(&body).bit_fields
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rof; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :rof; initial_value 0xabcd }
        end

        register_file do
          name 'register_file_1'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rof; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :rof; initial_value 0xabcd }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH   => 1,
            STORAGE => false
          )
          port map (
            i_clk             => '0',
            i_rst_n           => '0',
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(0 downto 0),
            i_sw_write_enable => "0",
            i_sw_write_mask   => bit_field_write_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => slice(x"0", 1, 0),
            i_mask            => (others => '1'),
            o_value           => open,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH   => 16,
            STORAGE => false
          )
          port map (
            i_clk             => '0',
            i_rst_n           => '0',
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(31 downto 16),
            i_sw_write_enable => "0",
            i_sw_write_mask   => bit_field_write_mask(31 downto 16),
            i_sw_write_data   => bit_field_write_data(31 downto 16),
            o_sw_read_data    => bit_field_read_data(31 downto 16),
            o_sw_value        => bit_field_value(31 downto 16),
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => slice(x"abcd", 16, 0),
            i_mask            => (others => '1'),
            o_value           => open,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH   => 1,
            STORAGE => false
          )
          port map (
            i_clk             => '0',
            i_rst_n           => '0',
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(0 downto 0),
            i_sw_write_enable => "0",
            i_sw_write_mask   => bit_field_write_mask(0 downto 0),
            i_sw_write_data   => bit_field_write_data(0 downto 0),
            o_sw_read_data    => bit_field_read_data(0 downto 0),
            o_sw_value        => bit_field_value(0 downto 0),
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => slice(x"0", 1, 0),
            i_mask            => (others => '1'),
            o_value           => open,
            o_value_unmasked  => open
          );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        u_bit_field: entity work.rggen_bit_field
          generic map (
            WIDTH   => 16,
            STORAGE => false
          )
          port map (
            i_clk             => '0',
            i_rst_n           => '0',
            i_sw_valid        => bit_field_valid,
            i_sw_read_mask    => bit_field_read_mask(31 downto 16),
            i_sw_write_enable => "0",
            i_sw_write_mask   => bit_field_write_mask(31 downto 16),
            i_sw_write_data   => bit_field_write_data(31 downto 16),
            o_sw_read_data    => bit_field_read_data(31 downto 16),
            o_sw_value        => bit_field_value(31 downto 16),
            i_hw_write_enable => "0",
            i_hw_write_data   => (others => '0'),
            i_hw_set          => (others => '0'),
            i_hw_clear        => (others => '0'),
            i_value           => slice(x"abcd", 16, 0),
            i_mask            => (others => '1'),
            o_value           => open,
            o_value_unmasked  => open
          );
      CODE
    end
  end
end
