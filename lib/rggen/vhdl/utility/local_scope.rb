# frozen_string_literal: true

module RgGen
  module VHDL
    module Utility
      class LocalScope < SystemVerilog::Common::Utility::StructureDefinition
        define_attribute :name
        define_attribute :loop_size
        define_attribute :signals

        private

        def header_code(code)
          block_header_code(code)
          generate_for_header(code)
        end

        def block_header_code(code)
          code << "#{name}: block" << nl
          header_begin(code, no_loop?)
        end

        def no_loop?
          loop_size.nil? || loop_size.empty?
        end

        def generate_for_header(code)
          loop_size&.each_with_index do |(loop_variable, size), i|
            code.indent += 2
            generate_for(code, loop_variable, size, i)
          end
        end

        def generate_for(code, loop_variable, size, loop_depth)
          code << "g: for #{loop_variable} in 0 to #{size - 1} generate" << nl
          header_begin(code, last_loop?(loop_depth))
        end

        def last_loop?(loop_depth)
          loop_depth == (loop_size.size - 1)
        end

        def header_begin(code, include_declarations)
          signal_declarations(code) if include_declarations
          code << 'begin' << nl
        end

        def signal_declarations(code)
          indent(code, 2) do
            add_declarations_to_body(code, Array(signals))
          end
        end

        def footer_code(code)
          loop_size&.each { footer(code, 'generate', true) }
          footer(code, 'block', false)
        end

        def footer(code, kind, decrease_indent)
          code << "end #{kind};" << nl
          code.indent -= 2 if decrease_indent
        end
      end
    end
  end
end
