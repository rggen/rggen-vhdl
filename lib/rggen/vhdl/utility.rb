# frozen_string_literal: true

module RgGen
  module VHDL
    module Utility
      include Core::Utility::CodeUtility

      private

      def assign(lhs, rhs)
        "#{lhs} <= #{rhs};"
      end

      def bin(value, width = nil)
        width && format("\"%0*b\"", width, value) || "'#{value[0]}'"
      end

      def hex(value, width)
        print_width = (width + 3) / 4
        format("x\"%0*x\"", print_width, value)
      end
    end
  end
end
