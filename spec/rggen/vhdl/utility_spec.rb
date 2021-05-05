# frozen_string_literal: true

RSpec.describe RgGen::VHDL::Utility do
  let(:vhdl) do
    Class.new { include RgGen::VHDL::Utility }.new
  end

  describe '#assign' do
    let(:lhs) { RgGen::VHDL::Utility::Identifier.new(:foo) }

    let(:rhs) do
      ['x"ab"', RgGen::VHDL::Utility::Identifier.new(:bar)]
    end

    it '継続代入のコード片を返す' do
      expect(vhdl.send(:assign, lhs, rhs[0])).to eq 'foo <= x"ab";'
      expect(vhdl.send(:assign, lhs[1], rhs[1])).to eq 'foo(1) <= bar;'
    end
  end

  describe '#bin' do
    it '与えられた数の2進数表現を返す' do
      expect(vhdl.send(:bin, 1)).to eq "'1'"
      expect(vhdl.send(:bin, 0)).to eq "'0'"
      expect(vhdl.send(:bin, 1, 1)).to eq '"1"'
      expect(vhdl.send(:bin, 0, 1)).to eq '"0"'
      expect(vhdl.send(:bin, 1, 2)).to eq '"01"'
      expect(vhdl.send(:bin, 0, 2)).to eq '"00"'
      expect(vhdl.send(:bin, 2, 2)).to eq '"10"'
      expect(vhdl.send(:bin, 2, 3)).to eq '"010"'
    end
  end

  describe '#hex' do
    it '与えられた数の16進数表現を返す' do
      expect(vhdl.send(:hex, 0x00, 1)).to eq 'x"0"'
      expect(vhdl.send(:hex, 0x01, 1)).to eq 'x"1"'
      expect(vhdl.send(:hex, 0x00, 4)).to eq 'x"0"'
      expect(vhdl.send(:hex, 0x01, 4)).to eq 'x"1"'
      expect(vhdl.send(:hex, 0x00, 5)).to eq 'x"00"'
      expect(vhdl.send(:hex, 0x01, 5)).to eq 'x"01"'
      expect(vhdl.send(:hex, 0xab, 8)).to eq 'x"ab"'
      expect(vhdl.send(:hex, 0xab, 9)).to eq 'x"0ab"'
    end
  end
end
