# This is going to create a demonstration of the parallax effect
# by creating some textures over a fake viewport and moving them.
# This stage is divided up by keyboard events (pressing space)
# to illustrate the motion.

define_stage :wireframe02 do
  requires :tween_manager

  curtain_up do
    stagehand = create_actor :stagehand
    rate = 0.05  # speed of tweens
    number_of_textures_created = 0

    center_x = viewport.width / 2
    center_y = viewport.height / 2
    position_1 = center_x - fake_width
    position_2 = center_x
    position_3 = center_x + fake_width

    fake_width = viewport.width / 4
    fake_height = viewport.height / 4

    # put our textures in a line and move them for the demo
    conveyor_belt_y = center_y

    title = create_actor :label, x:center_x - 234, y:25, text:"Parallax Movement", font_size: 64
    fake_viewport = create_actor :fake_viewport,
      x:center_x, y:center_y, width:fake_width+2, height:fake_height+2

    # kuler theme - vitamin c
    blue = Color.new(80, 0, 67, 88)
    green = Color.new(80, 31, 138, 112)
    lime = Color.new(80, 190, 219, 57)
    yellow = Color.new(80, 255, 255, 26)
    orange = Color.new(80, 253, 116, 0)

    # initial placement positions

    textures = []
    textures << create_actor(:texture, x: position_1, y: conveyor_belt_y,
      text:   number_of_textures_created.ordinal.capitalize,
      width:  viewport.width/4,
      height: viewport.height/4,
      fill:   orange
      )

    textures << create_actor(:texture, x:position_2, y:conveyor_belt_y,
      text:   number_of_textures_created.ordinal.capitalize,
      width:  viewport.width/4,
      height: viewport.height/4,
      fill:   green
      )

    textures << create_actor(:texture, x:position_3, y:conveyor_belt_y,
      text:   number_of_textures_created.ordinal.capitalize,
      width:  viewport.width/4,
      height: viewport.height/4,
      fill:   lime
      )
    number_of_textures_created = 3

    stagehand.when(:start_sliding) do
      textures.each do |texture|
        destination_x = texture.x - fake_width
        distance_x = (texture.x - destination_x).abs
        tween_manager.tween_properties texture,
          {x: destination_x, y:texture.y}, distance_x / rate, Tween::Linear
      end
    end

    stagehand.when(:delete) do
      textures.first.remove
    end

    stagehand.when(:introduce) do
      number_of_textures_created += 1
      spawn_x = textures.last.x + textures.last.width
      fourth = create_actor(:texture, x: spawn_x, y: conveyor_belt_y,
        text:   number_of_textures_created.ordinal.capitalize,
        width:  viewport.width/4,
        height: viewport.height/4,
        fill:   blue
        )

      # We can't just blindly tween left because we have to consider that the train
      # of already moving textures has elapsed time, so if we tween a static amount
      # this new guy will overlap or who knows.
      fourth_distance = (textures.last.x - position_2).abs
      time_delta = fourth_distance / rate
      fourth_destination = fourth.x - fourth_distance
      # stack level too deep if distance is zero
      if fourth_distance > 0
        tween_manager.tween_properties fourth, {x: fourth_destination, y:fourth.y}, time_delta, Tween::Linear
      end
      textures << fourth
    end

    # :down is key down, KbEscape is defined in gamebox/lib/gamebox/constants.rb
    input_manager.reg :down, K_SPACE do
      stagehand.progression_counter += 1

      case stagehand.progression_counter
      when 1
        stagehand.fire :start_sliding
      when 2
        stagehand.fire :delete
      when 3
        stagehand.fire :introduce
      when 4
        stagehand.fire :start_sliding
      else
        fire :next_stage
      end
    end

    input_manager.reg :down, K_A do
      stagehand.fire :introduce
    end

    input_manager.reg :down, K_R do
      fire :restart_stage
    end

  end

  curtain_down do
    fire :remove_me
    input_manager.clear_hooks
  end

  helpers do
  end

end
