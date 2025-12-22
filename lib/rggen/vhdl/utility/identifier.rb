# frozen_string_literal: true

module RgGen
  module VHDL
    module Utility
      class Identifier < SystemVerilog::Common::Utility::Identifier
        def __create_select__(array_index_or_lsb, lsb_or_width, width)
          if array_index_or_lsb.is_a?(Array)
            __array_select__(array_index_or_lsb, lsb_or_width, width)
          elsif lsb_or_width
            __array_slice__(array_index_or_lsb, lsb_or_width)
          else
            "(#{array_index_or_lsb})"
          end
        end

        def __array_select__(array_index, lsb, width)
          if @width
            lsb = __serialized_lsb__(array_index, lsb)
            __array_slice__(lsb, width || @width)
          else
            "(#{__serialized_index__(array_index)})"
          end
        end

        def __array_slice__(lsb, width)
          if integer?(width)
            "(#{__reduce_array__([lsb, width - 1], :+, 0)} downto #{lsb})"
          else
            "(#{__reduce_array__([lsb, width], :+, 0)}-1 downto #{lsb})"
          end
        end
      end
    end
  end
end
