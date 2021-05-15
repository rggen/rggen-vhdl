# frozen_string_literal: true

RSpec.describe 'bit_field/vhdl_top' do
  include_context 'vhdl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :vhdl_top)
    RgGen.enable(:register_file, :vhdl_top)
    RgGen.enable(:register, :vhdl_top)
    RgGen.enable(:bit_field, :vhdl_top)
  end

  def create_bit_fields(&body)
    create_vhdl(&body).bit_fields
  end

  context '単一の初期値が指定されている場合' do
    describe '#initial_value' do
      it '初期値リテラルを返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end
        end

        expect(bit_fields[0].initial_value).to eq 'x"0"'
        expect(bit_fields[1].initial_value).to eq 'x"01"'
        expect(bit_fields[2].initial_value).to eq 'x"02"'
        expect(bit_fields[3].initial_value).to eq 'x"0"'
        expect(bit_fields[4].initial_value).to eq 'x"01"'
        expect(bit_fields[5].initial_value).to eq 'x"02"'
        expect(bit_fields[6].initial_value).to eq 'x"0"'
        expect(bit_fields[7].initial_value).to eq 'x"01"'
        expect(bit_fields[8].initial_value).to eq 'x"02"'
        expect(bit_fields[9].initial_value).to eq 'x"0"'
        expect(bit_fields[10].initial_value).to eq 'x"01"'
        expect(bit_fields[11].initial_value).to eq 'x"02"'
      end
    end
  end

  context '配列化された初期値が指定されている場合' do
    describe '#initial_value' do
      it '配列の各要素の連接を初期値リテラルとして返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end
        end

        expect(bit_fields[0].initial_value).to eq 'x"00"'
        expect(bit_fields[1].initial_value).to eq 'x"0201"'
        expect(bit_fields[2].initial_value).to eq 'x"00"'
        expect(bit_fields[3].initial_value).to eq 'x"0201"'
        expect(bit_fields[4].initial_value).to eq 'x"00"'
        expect(bit_fields[5].initial_value).to eq 'x"0201"'
        expect(bit_fields[6].initial_value).to eq 'x"00"'
        expect(bit_fields[7].initial_value).to eq 'x"0201"'
      end
    end
  end

  context 'ジェネリック化された初期値が指定されている場合' do
    let(:bit_fields) do
      create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
        end

        register do
          name 'register_1'
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
        end

        register_file do
          name 'register_file_2'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end
        end

        register_file do
          name 'register_file_3'
          size [2]
          register do
            name 'register_0'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end
        end
      end
    end

    it 'ジェネリック#initial_valueを持つ' do
      expect(bit_fields[0]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', width: 1, default: 'repeat(x"0", 1, 1)'
      )
      expect(bit_fields[1]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', width: 8, default: 'repeat(x"01", 8, 1)'
      )
      expect(bit_fields[2]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', width: 16, default: 'repeat(x"02", 8, 2)'
      )
      expect(bit_fields[3]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_0_INITIAL_VALUE', width: 1, default: 'repeat(x"0", 1, 1)'
      )
      expect(bit_fields[4]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_1_INITIAL_VALUE', width: 8, default: 'repeat(x"01", 8, 1)'
      )
      expect(bit_fields[5]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_1_BIT_FIELD_2_INITIAL_VALUE', width: 16, default: 'repeat(x"02", 8, 2)'
      )
      expect(bit_fields[6]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', width: 1, default: 'repeat(x"0", 1, 1)'
      )
      expect(bit_fields[7]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', width: 8, default: 'repeat(x"01", 8, 1)'
      )
      expect(bit_fields[8]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', width: 16, default: 'repeat(x"02", 8, 2)'
      )
      expect(bit_fields[9]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE', width: 1, default: 'repeat(x"0", 1, 1)'
      )
      expect(bit_fields[10]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE', width: 8, default: 'repeat(x"01", 8, 1)'
      )
      expect(bit_fields[11]).to have_generic(
        :register_block, :initial_value,
        name: 'REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE', width: 16, default: 'repeat(x"02", 8, 2)'
      )
    end

    describe '#initial_value' do
      it 'ジェネリックの識別子を返す' do
        expect(bit_fields[0].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[1].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[2].initial_value).to match_identifier('REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[3].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[4].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[5].initial_value).to match_identifier('REGISTER_1_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[6].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[7].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[8].initial_value).to match_identifier('REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
        expect(bit_fields[9].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE')
        expect(bit_fields[10].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE')
        expect(bit_fields[11].initial_value).to match_identifier('REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE')
      end
    end
  end

  describe '#generate_code' do
    it 'ビットフィールド階層のコードを出力する' do
      bit_fields = create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_3'
          offset_address 0x30
          bit_field { bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_0: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 1,
              INITIAL_VALUE   => slice(x"0", 1, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(0 downto 0),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(0 downto 0),
              i_sw_write_data   => bit_field_write_data(0 downto 0),
              o_sw_read_data    => bit_field_read_data(0 downto 0),
              o_sw_value        => bit_field_value(0 downto 0),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_0_bit_field_0,
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[1]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_1: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 8,
              INITIAL_VALUE   => slice(x"00", 8, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(15 downto 8),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(15 downto 8),
              i_sw_write_data   => bit_field_write_data(15 downto 8),
              o_sw_read_data    => bit_field_read_data(15 downto 8),
              o_sw_value        => bit_field_value(15 downto 8),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_0_bit_field_1,
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[2]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_2: block
        begin
          g: for i in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 1,
                INITIAL_VALUE   => slice(x"0", 1, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(16+1*i+0 downto 16+1*i),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(16+1*i+0 downto 16+1*i),
                i_sw_write_data   => bit_field_write_data(16+1*i+0 downto 16+1*i),
                o_sw_read_data    => bit_field_read_data(16+1*i+0 downto 16+1*i),
                o_sw_value        => bit_field_value(16+1*i+0 downto 16+1*i),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_0_bit_field_2(1*(i)+0 downto 1*(i)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[3]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_3: block
        begin
          g: for i in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(REGISTER_0_BIT_FIELD_3_INITIAL_VALUE, 2, i),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(20+2*i+1 downto 20+2*i),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(20+2*i+1 downto 20+2*i),
                i_sw_write_data   => bit_field_write_data(20+2*i+1 downto 20+2*i),
                o_sw_read_data    => bit_field_read_data(20+2*i+1 downto 20+2*i),
                o_sw_value        => bit_field_value(20+2*i+1 downto 20+2*i),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_0_bit_field_3(2*(i)+1 downto 2*(i)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[4]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_4: block
        begin
          g: for i in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"4", 2, i),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(24+4*i+1 downto 24+4*i),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(24+4*i+1 downto 24+4*i),
                i_sw_write_data   => bit_field_write_data(24+4*i+1 downto 24+4*i),
                o_sw_read_data    => bit_field_read_data(24+4*i+1 downto 24+4*i),
                o_sw_value        => bit_field_value(24+4*i+1 downto 24+4*i),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_0_bit_field_4(2*(i)+1 downto 2*(i)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[5]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_0: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 1,
              INITIAL_VALUE   => slice(x"0", 1, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(0 downto 0),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(0 downto 0),
              i_sw_write_data   => bit_field_write_data(0 downto 0),
              o_sw_read_data    => bit_field_read_data(0 downto 0),
              o_sw_value        => bit_field_value(0 downto 0),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_1_bit_field_0(1*(i)+0 downto 1*(i)),
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[6]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_1: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 8,
              INITIAL_VALUE   => slice(x"00", 8, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(15 downto 8),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(15 downto 8),
              i_sw_write_data   => bit_field_write_data(15 downto 8),
              o_sw_read_data    => bit_field_read_data(15 downto 8),
              o_sw_value        => bit_field_value(15 downto 8),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_1_bit_field_1(8*(i)+7 downto 8*(i)),
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[7]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_2: block
        begin
          g: for j in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 1,
                INITIAL_VALUE   => slice(x"0", 1, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(16+1*j+0 downto 16+1*j),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(16+1*j+0 downto 16+1*j),
                i_sw_write_data   => bit_field_write_data(16+1*j+0 downto 16+1*j),
                o_sw_read_data    => bit_field_read_data(16+1*j+0 downto 16+1*j),
                o_sw_value        => bit_field_value(16+1*j+0 downto 16+1*j),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_1_bit_field_2(1*(2*i+j)+0 downto 1*(2*i+j)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[8]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_3: block
        begin
          g: for j in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(REGISTER_1_BIT_FIELD_3_INITIAL_VALUE, 2, j),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(20+2*j+1 downto 20+2*j),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(20+2*j+1 downto 20+2*j),
                i_sw_write_data   => bit_field_write_data(20+2*j+1 downto 20+2*j),
                o_sw_read_data    => bit_field_read_data(20+2*j+1 downto 20+2*j),
                o_sw_value        => bit_field_value(20+2*j+1 downto 20+2*j),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_1_bit_field_3(2*(2*i+j)+1 downto 2*(2*i+j)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[9]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_4: block
        begin
          g: for j in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"4", 2, j),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(24+4*j+1 downto 24+4*j),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(24+4*j+1 downto 24+4*j),
                i_sw_write_data   => bit_field_write_data(24+4*j+1 downto 24+4*j),
                o_sw_read_data    => bit_field_read_data(24+4*j+1 downto 24+4*j),
                o_sw_value        => bit_field_value(24+4*j+1 downto 24+4*j),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_1_bit_field_4(2*(2*i+j)+1 downto 2*(2*i+j)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[10]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_0: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 1,
              INITIAL_VALUE   => slice(x"0", 1, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(0 downto 0),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(0 downto 0),
              i_sw_write_data   => bit_field_write_data(0 downto 0),
              o_sw_read_data    => bit_field_read_data(0 downto 0),
              o_sw_value        => bit_field_value(0 downto 0),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_2_bit_field_0(1*(2*i+j)+0 downto 1*(2*i+j)),
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[11]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_1: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 8,
              INITIAL_VALUE   => slice(x"00", 8, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(15 downto 8),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(15 downto 8),
              i_sw_write_data   => bit_field_write_data(15 downto 8),
              o_sw_read_data    => bit_field_read_data(15 downto 8),
              o_sw_value        => bit_field_value(15 downto 8),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_2_bit_field_1(8*(2*i+j)+7 downto 8*(2*i+j)),
              o_value_unmasked  => open
            );
        end block;
      CODE

      expect(bit_fields[12]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_2: block
        begin
          g: for k in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 1,
                INITIAL_VALUE   => slice(x"0", 1, 0),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(16+1*k+0 downto 16+1*k),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(16+1*k+0 downto 16+1*k),
                i_sw_write_data   => bit_field_write_data(16+1*k+0 downto 16+1*k),
                o_sw_read_data    => bit_field_read_data(16+1*k+0 downto 16+1*k),
                o_sw_value        => bit_field_value(16+1*k+0 downto 16+1*k),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_2_bit_field_2(1*(4*i+2*j+k)+0 downto 1*(4*i+2*j+k)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[13]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_3: block
        begin
          g: for k in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(REGISTER_2_BIT_FIELD_3_INITIAL_VALUE, 2, k),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(20+2*k+1 downto 20+2*k),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(20+2*k+1 downto 20+2*k),
                i_sw_write_data   => bit_field_write_data(20+2*k+1 downto 20+2*k),
                o_sw_read_data    => bit_field_read_data(20+2*k+1 downto 20+2*k),
                o_sw_value        => bit_field_value(20+2*k+1 downto 20+2*k),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_2_bit_field_3(2*(4*i+2*j+k)+1 downto 2*(4*i+2*j+k)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[14]).to generate_code(:register, :top_down, <<~'CODE')
        g_bit_field_4: block
        begin
          g: for k in 0 to 1 generate
          begin
            u_bit_field: entity work.rggen_bit_field
              generic map (
                WIDTH           => 2,
                INITIAL_VALUE   => slice(x"4", 2, k),
                SW_READ_ACTION  => RGGEN_READ_DEFAULT,
                SW_WRITE_ONCE   => false
              )
              port map (
                i_clk             => i_clk,
                i_rst_n           => i_rst_n,
                i_sw_valid        => bit_field_valid,
                i_sw_read_mask    => bit_field_read_mask(24+4*k+1 downto 24+4*k),
                i_sw_write_enable => "1",
                i_sw_write_mask   => bit_field_write_mask(24+4*k+1 downto 24+4*k),
                i_sw_write_data   => bit_field_write_data(24+4*k+1 downto 24+4*k),
                o_sw_read_data    => bit_field_read_data(24+4*k+1 downto 24+4*k),
                o_sw_value        => bit_field_value(24+4*k+1 downto 24+4*k),
                i_hw_write_enable => "0",
                i_hw_write_data   => (others => '0'),
                i_hw_set          => (others => '0'),
                i_hw_clear        => (others => '0'),
                i_value           => (others => '0'),
                i_mask            => (others => '1'),
                o_value           => o_register_2_bit_field_4(2*(4*i+2*j+k)+1 downto 2*(4*i+2*j+k)),
                o_value_unmasked  => open
              );
          end generate;
        end block;
      CODE

      expect(bit_fields[15]).to generate_code(:register, :top_down, <<~'CODE')
        g_register_3: block
        begin
          u_bit_field: entity work.rggen_bit_field
            generic map (
              WIDTH           => 32,
              INITIAL_VALUE   => slice(x"00000000", 32, 0),
              SW_READ_ACTION  => RGGEN_READ_DEFAULT,
              SW_WRITE_ONCE   => false
            )
            port map (
              i_clk             => i_clk,
              i_rst_n           => i_rst_n,
              i_sw_valid        => bit_field_valid,
              i_sw_read_mask    => bit_field_read_mask(31 downto 0),
              i_sw_write_enable => "1",
              i_sw_write_mask   => bit_field_write_mask(31 downto 0),
              i_sw_write_data   => bit_field_write_data(31 downto 0),
              o_sw_read_data    => bit_field_read_data(31 downto 0),
              o_sw_value        => bit_field_value(31 downto 0),
              i_hw_write_enable => "0",
              i_hw_write_data   => (others => '0'),
              i_hw_set          => (others => '0'),
              i_hw_clear        => (others => '0'),
              i_value           => (others => '0'),
              i_mask            => (others => '1'),
              o_value           => o_register_3,
              o_value_unmasked  => open
            );
        end block;
      CODE
    end
  end
end
