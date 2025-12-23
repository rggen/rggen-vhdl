# frozen_string_literal: true

RSpec.describe RgGen::VHDL::Utility::Identifier do
  def match_identifier(expectation)
    be_instance_of(described_class).and match_string(expectation)
  end

  let(:identifier) do
    described_class.new(name)
  end

  let(:name) do
    :foo
  end

  describe '#[]' do
    context 'nilが与えられた場合' do
      it '自信を返す' do
        expect(identifier[nil]).to be identifier
      end
    end

    context 'ビット選択がされた場合' do
      let(:index) { rand(0..15) }

      it 'ビット選択された識別子を返す' do
        expect(identifier[index]).to match_identifier("#{name}(#{index})")
      end
    end

    context '部分選択がされた場合' do
      let(:lsb) do
        rand(0..15)
      end

      let(:width) do
        rand(1..(16 - lsb))
      end

      it '部分選択された識別子を返す' do
        expect(identifier[lsb, width]).to match_identifier("#{name}(#{lsb + width - 1} downto #{lsb})")
      end
    end

    context '配列選択がされた場合' do
      let(:array_size) { [[2, 3, 4], [:FOO_SIZE, :BAR_SIZE, :BAZ_SIZE]] }

      let(:array_index) { [[0, 1, 2], [:i, :j, :k]] }

      def apply_array_attributes(width, array_size)
        identifier.__width__(width)
        identifier.__array_size__(array_size)
      end

      it '配列選択された識別子を返す' do
        apply_array_attributes(nil, array_size[0])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(6)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(12*i+4*j+k)")

        apply_array_attributes(nil, array_size[1])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)")

        apply_array_attributes(1, array_size[0])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(6 downto 6)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(1*(12*i+4*j+k)+0 downto 1*(12*i+4*j+k))")

        apply_array_attributes(1, array_size[1])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(1*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+0 downto 1*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2))")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(1*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+0 downto 1*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k))")

        apply_array_attributes(16, array_size[0])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(111 downto 96)")
        expect(identifier[array_index[0], 1, 2]).to match_identifier("#{name}(98 downto 97)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(16*(12*i+4*j+k)+15 downto 16*(12*i+4*j+k))")
        expect(identifier[array_index[1], 1, 2]).to match_identifier("#{name}(16*(12*i+4*j+k)+1+1 downto 16*(12*i+4*j+k)+1)")

        apply_array_attributes(16, array_size[1])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(16*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+15 downto 16*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2))")
        expect(identifier[array_index[0], 1, 2]).to match_identifier("#{name}(16*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+1+1 downto 16*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+1)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(16*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+15 downto 16*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k))")
        expect(identifier[array_index[1], 1, 2]).to match_identifier("#{name}(16*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+1+1 downto 16*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+1)")

        apply_array_attributes('WIDTH', array_size[1])
        expect(identifier[array_index[0]]).to match_identifier("#{name}(WIDTH*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+WIDTH-1 downto WIDTH*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2))")
        expect(identifier[array_index[0], 1, 2]).to match_identifier("#{name}(WIDTH*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+1+1 downto WIDTH*(BAR_SIZE*BAZ_SIZE*0+BAZ_SIZE*1+2)+1)")
        expect(identifier[array_index[1]]).to match_identifier("#{name}(WIDTH*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+WIDTH-1 downto WIDTH*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k))")
        expect(identifier[array_index[1], 1, 2]).to match_identifier("#{name}(WIDTH*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+1+1 downto WIDTH*(BAR_SIZE*BAZ_SIZE*i+BAZ_SIZE*j+k)+1)")
      end
    end
  end
end
