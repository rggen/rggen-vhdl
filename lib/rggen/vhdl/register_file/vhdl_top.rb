# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :vhdl_top) do
  vhdl do
    include RgGen::SystemVerilog::RTL::RegisterIndex

    main_code :register_file do
      local_scope("g_#{register_file.name}") do |scope|
        scope.loop_size loop_size
        scope.body(&method(:body_code))
      end
    end

    private

    def loop_size
      (register_file.array? || nil) &&
        local_loop_variables.zip(register_file.array_size).to_h
    end

    def body_code(code)
      register_file.generate_code(code, :register_file, :top_down, 1)
    end
  end
end
