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
        width && format('"%0*b"', width, value) || "'#{value[0]}'"
      end

      def hex(value, width)
        print_width = (width + 3) / 4
        format('x"%0*x"', print_width, value)
      end

      def width_cast(expression, _width)
        expression
      end

      def local_scope(scope_name, attributes = {}, &block)
        LocalScope.new(attributes.merge(name: scope_name), &block).to_code
      end
    end
  end
end
