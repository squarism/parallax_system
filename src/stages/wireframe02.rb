define_stage :wireframe02 do
  requires :tween_manager

  curtain_up do
    center_x = viewport.width / 2
    center_y = viewport.height / 2

    fake_width = viewport.width / 4
    fake_height = viewport.height / 4

    # put our textures in a line and move them for the demo
    conveyor_belt_y = center_y

    title = create_actor :label, x:center_x - 234, y:25, text:"A Parallax System", font_size: 64, font_name: "remi.ttf"
    fake_viewport = create_actor :fake_viewport,
      x:center_x, y:center_y, width:fake_width+2, height:fake_height+2

    stagehand = create_actor :stagehand

    # kuler theme - vitamin c
    blue = Color.new(80, 0, 67, 88)
    green = Color.new(80, 31, 138, 112)
    lime = Color.new(80, 190, 219, 57)
    yellow = Color.new(80, 255, 255, 26)
    orange = Color.new(80, 253, 116, 0)

    textures = []
    textures << create_actor(:texture,
      text:"One",
      x:center_x - fake_width, y:conveyor_belt_y,
      width:viewport.width/4, height:viewport.height/4,
      fill: orange)

    textures << create_actor(:texture,
      x:center_x, y:conveyor_belt_y,
      text:"Two",
      width:viewport.width/4, height:viewport.height/4,
      fill: green)

    textures << create_actor(:texture,
      x:center_x + fake_width, y:conveyor_belt_y,
      text:"Three",
      width:viewport.width/4, height:viewport.height/4,
      fill: lime)

    textures.each do |texture|
      destination_x = texture.x - texture.width
      tween_manager.tween_properties texture, {x: destination_x, y:texture.y}, 3_000, Tween::Linear
    end


    stagehand.when(:delete) do
      puts "delete"
    end

    stagehand.when(:introduce) do
      puts "introduce"
    end

    stagehand.when(:slide) do
      puts "slide"
    end

    # :down is key down, KbEscape is defined in gamebox/lib/gamebox/constants.rb
    input_manager.reg :down, K_SPACE do
      stagehand.progression_counter += 1

      case stagehand.progression_counter
      when 1
        stagehand.fire :delete
      when 2
        stagehand.fire :introduce
      when 3
        stagehand.fire :slide
      else
        fire :next_stage
      end
    end
  end

  curtain_down do
    fire :remove_me
    input_manager.clear_hooks
  end

  helpers do
  end

end
