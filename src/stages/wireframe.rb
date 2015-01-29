define_stage :wireframe do
  requires :tween_manager

  curtain_up do |*args|
    opts = args.first || {}
    common_setup

    @stagehand.when(:create_scene) do
      @title = create_actor :label, x:center_x - 234, y:25, text:"A Parallax System", font_size: 64
      @fake_viewport = create_actor :fake_viewport,
        x:center_x, y:center_y, width:fake_viewport_width+2, height:fake_viewport_height+2
    end

    @stagehand.when(:introduce_textures) do
      @title.text = "Offscreen Textures"
      @textures = []
      @textures << create_actor(:texture, x:position_1, y:conveyor_belt_y,
        text:   "First",
        # TODO all these fake_viewport_width
        width:  viewport.width/4,
        height: viewport.height/4,
        fill:   orange
        )

      @textures << create_actor(:texture, x:position_2, y:conveyor_belt_y,
        text:   "Second",
        width:  viewport.width/4,
        height: viewport.height/4,
        fill:   green
        )

      @textures << create_actor(:texture, x:position_3, y:conveyor_belt_y,
        text:   "Third",
        width:  viewport.width/4,
        height: viewport.height/4,
        fill:   lime
        )
    end

    # slide all the textures into position, demonstrating we
    # can create textures anywhere offscreen but the effect
    # requires them to slide in from offscreen
    @stagehand.when(:align_to_conveyor_belt) do
      @textures.each do |texture|
        distance_y = (texture.y - center_y).abs
        tween_manager.tween_properties texture,
          {x: texture.x, y:center_y}, distance_y / 0.18, Tween::Quad::InOut
      end
    end

    @stagehand.when(:start_sliding) do
       @textures.each do |texture|
        destination_x = texture.x - fake_viewport_width
        distance_x = (texture.x - destination_x).abs
        tween_manager.tween_properties texture,
          {x: destination_x, y:texture.y}, distance_x / rate, Tween::Linear
      end
    end

    @stagehand.when(:delete) do
      @textures.first.remove
      @textures.delete_at 0
    end

    @stagehand.when(:introduce) do |name|
      spawn_x = @textures.last.x + @textures.last.width
      spawned = create_actor(:texture, x: spawn_x, y: @textures.last.y,
        text:   name,
        width:  viewport.width/4,
        height: viewport.height/4,
        fill:   blue
        )

      # We can't just blindly tween left because we have to consider that the train
      # of already moving textures has elapsed time, so if we tween a static amount
      # this new guy will overlap or who knows.
      spawned_destination = spawned.x - (@textures.last.x - fake_viewport_width).abs + fake_viewport_width
      spawned_distance = (spawned.x - spawned_destination).abs
      time_delta = spawned_distance / rate
      # stack level too deep if distance is zero
      if spawned_distance > 0
        tween_manager.tween_properties spawned, {x: spawned_destination, y:spawned.y}, time_delta, Tween::Linear
      end
      @textures << spawned
    end

    @stagehand.fire :create_scene

    # replay the scene up to some point
    # TODO: the case/switch statement is making this too rule-based
    # if there was a hash of a "scene flow" then you could select a range of symbols to fire or something
    if opts.has_key? :start_on
      if opts[:start_on] == 2
        @stagehand.fire :introduce_textures
        @stagehand.fire :align_to_conveyor_belt
        @stagehand.progression_counter = 2
      end
    end


    # interactivity might not be the best idea here because of edge cases
    # so we're just going to progress the scene with the spacebar
    # TODO: you can't press space too fast, it's not that smart.  this is
    # just a presentation.
    input_manager.reg :down, K_SPACE do
      @stagehand.progression_counter += 1

      case @stagehand.progression_counter
      when 1
        @stagehand.fire :introduce_textures
      when 2
        @title.text = "Horizontal Parallax"
        @stagehand.fire :align_to_conveyor_belt
      when 3
        @title.text = "Parallax Movement"
        @stagehand.fire :delete
        @stagehand.fire :introduce, "Fourth"
        @stagehand.fire :start_sliding
      when 4
        @title.text = "Creating Respawns"
        @stagehand.fire :delete
        @stagehand.fire :introduce, "Fifth"
        @textures.last.fill = orange
        @stagehand.fire :start_sliding
      when 5
        @title.text = "Moving Respawns"
        @stagehand.fire :delete
        @stagehand.fire :introduce, "Third"
        @textures.last.fill = lime
        @stagehand.fire :start_sliding
      when 6
        @stagehand.fire :delete
        @stagehand.fire :introduce, "Fourth"
        @textures.last.fill = blue
        @stagehand.fire :start_sliding
      when 7
        @stagehand.fire :delete
        @stagehand.fire :introduce, "Fifth"
        @textures.last.fill = orange
        @stagehand.fire :start_sliding
      when 8
        # TODO: ha, I don't have centering code.
        @title.text = "             Ok."
        # dramatic pause
      else
        fire :next_stage
      end
    end

    # :down is key down, codes are defined in gamebox/lib/gamebox/constants.rb
    input_manager.reg :down, K_R do
      fire :restart_stage, {start_on: 2}
    end

  end

  curtain_down do |*args|
    fire :remove_me
    input_manager.clear_hooks
  end

  helpers do
    def common_setup
      @stagehand = create_actor :stagehand
    end

    def fake_viewport_width
      viewport.width / 4
    end

    def fake_viewport_height
      viewport.height / 4
    end

    def center_x
      viewport.width / 2
    end

    def center_y
      viewport.height / 2
    end

    def position_1
      center_x - fake_viewport_width
    end

    def position_2
      center_x
    end

    def position_3
      center_x + fake_viewport_width
    end

    # put our textures in a line and move them for the demo
    def conveyor_belt_y
      center_y + center_y / 2 + 20
    end

    # kuler theme - vitamin c
    #   0,  67,  88  blue
    #  31, 138, 112  green
    # 190, 219,  57  lime
    # 255, 255,  26  yellow
    # 253, 116,   0  orange
    def blue
      Color.new(80, 0, 67, 88)
    end

    def green
      Color.new(80, 31, 138, 112)
    end

    def lime
      Color.new(80, 190, 219, 57)
    end

    def yellow
      Color.new(80, 255, 255, 26)
    end

    def orange
      Color.new(80, 253, 116, 0)
    end

    # speed of tweens
    def rate
      0.10
    end

  end

end
