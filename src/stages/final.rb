define_stage :final do

  curtain_up do

    input_manager.reg :down, K_SPACE do
      fire :next_stage
    end
  end

end