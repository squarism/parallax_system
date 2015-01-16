define_stage :wireframe00 do

  curtain_up do
    center_x = viewport.width / 2
    center_y = viewport.height / 2

    # put our textures in a line and move them for the demo
    conveyor_belt_y = center_y + center_y/2 + 20

    title = create_actor :label, x:center_x - 234, y:25, text:"A Parallax System", font_size: 64, font_name: "remi.ttf"
    fake_viewport = create_actor :fake_viewport,
      x:center_x, y:center_y, width:viewport.width/4, height:viewport.height/4

    # :down is key down, KbEscape is defined in gamebox/lib/gamebox/constants.rb
    input_manager.reg :down, K_SPACE do
      fire :next_stage
    end
  end

  curtain_down do
    fire :remove_me
    input_manager.clear_hooks
  end

  helpers do
  end

end
