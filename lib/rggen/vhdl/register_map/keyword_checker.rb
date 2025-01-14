# frozen_string_literal: true

module RgGen
  module VHDL
    module RegisterMap
      module KeywordChecker
        VHDL_KEYWORDS = [
          'abs', 'access', 'after', 'alias', 'all', 'and', 'architecture', 'array',
          'assert', 'assume', 'attribute', 'begin', 'block', 'body', 'buffer', 'bus',
          'case', 'component', 'configuration', 'constant', 'context', 'cover', 'default',
          'disconnect', 'downto', 'else', 'elsif', 'end', 'entity', 'exit', 'fairness',
          'file', 'for', 'force', 'function', 'generate', 'generic', 'group', 'guarded',
          'if', 'impure', 'in', 'inertial', 'inout', 'is', 'label', 'library', 'linkage',
          'literal', 'loop', 'map', 'mod', 'nand', 'new', 'next', 'nor', 'not', 'null',
          'of', 'on', 'open', 'or', 'others', 'out', 'package', 'parameter', 'port',
          'postponed', 'procedure', 'process', 'property', 'protected', 'private', 'pure',
          'range', 'record', 'register', 'reject', 'release', 'rem', 'report', 'restrict',
          'return', 'rol', 'ror', 'select', 'sequence', 'severity', 'signal', 'shared',
          'sla', 'sll', 'sra', 'srl', 'strong', 'subtype', 'then', 'to', 'transport',
          'type', 'unaffected', 'units', 'until', 'use', 'variable', 'view', 'vpkg',
          'vmode', 'vprop', 'vunit', 'wait', 'when', 'while', 'with', 'xnor', 'xor'
        ].freeze

        def self.included(klass)
          klass.class_eval do
            verify(:feature, prepend: true) do
              error_condition do
                @name && VHDL_KEYWORDS.any? { |kw| kw.casecmp?(@name) }
              end
              message do
                layer_name = component.layer.to_s.sub('_', ' ')
                "vhdl keyword is not allowed for #{layer_name} name: #{@name.downcase}"
              end
            end
          end
        end
      end
    end
  end
end
