define_stage :textured do
  requires :tween_manager

  curtain_up do |*args|
    opts = args.first || {}
    common_setup

    @stagehand.when(:create_scene) do
      @title = create_actor :label, x:center_x - 234, y:25, text:"Now Some Textures", font_size: 64
      @fake_viewport = create_actor :fake_viewport,
        x:center_x, y:center_y, width:fake_viewport_width+2, height:fake_viewport_height+2

      @textures = []
      @textures << create_actor(:sky_small, x: position_1, y: center_y,
        width:  fake_viewport_width,
        height: fake_viewport_height
        )

      @textures << create_actor(:sky_small, x:position_2, y:center_y,
        width:  fake_viewport_width,
        height: fake_viewport_height
        )

      @textures << create_actor(:sky_small, x:position_3, y:center_y,
        width:  fake_viewport_width,
        height: fake_viewport_height
        )
      # We can't just use textures.length all the time because we'll eventually be deleting textures
      # and we want to label them based on the total number created.
      @number_of_textures_created = @textures.count
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

    @stagehand.when(:introduce) do
      spawn_x = @textures.last.x + @textures.last.width
      # TODO all these create_actor should be not pasted methods
      spawned = create_actor(:sky_small, x: spawn_x, y: @textures.last.y,
        width:  fake_viewport_width,
        height: fake_viewport_height,
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

    @stagehand.when(:alpha_mask) do
      @l_mask = create_actor(:black, x: position_1 - 75, y: center_y,
        width: fake_viewport_width + 150, height: fake_viewport_height + 20, layer: 10, alpha:80)
      @r_mask = create_actor(:black, x: position_3 + 75, y: center_y,
        width: fake_viewport_width + 150, height: fake_viewport_height + 20, layer: 10, alpha:80)
    end

    @stagehand.when(:total_mask) do
      @l_mask.remove
      @r_mask.remove
      @l_mask = create_actor(:black, x: position_1 - 75, y: center_y,
        width: fake_viewport_width + 150, height: fake_viewport_height + 20,
        layer: 10, alpha:255)
      @r_mask = create_actor(:black, x: position_3 + 75, y: center_y,
        width: fake_viewport_width + 150, height: fake_viewport_height + 20, layer: 10, alpha:255)
      @fake_viewport.remove
      remove_texture_borders
    end

    @stagehand.fire :create_scene


    # interactivity might not be the best idea here because of edge cases
    # so we're just going to progress the scene with the spacebar
    input_manager.reg :down, K_SPACE do
      @stagehand.progression_counter += 1

      case @stagehand.progression_counter
      when 1
        @stagehand.fire :start_sliding
      when 2
        @stagehand.fire :delete
      when 3
        @stagehand.fire :introduce
        @stagehand.fire :start_sliding
      when 4
        remove_actors
        @stagehand.fire :create_scene
        @title.text = "Shade the Offscreen"
        @stagehand.fire :alpha_mask
      when 5
        cycle
      when 6
        remove_actors
        @stagehand.fire :create_scene
        @title.text = "Cover Offscreen"
        @stagehand.fire :total_mask
      when 7
        cycle
      else
        fire :next_stage
      end
    end

    # :down is key down, codes are defined in gamebox/lib/gamebox/constants.rb
    input_manager.reg :down, K_R do
      fire :restart_stage
    end

  end

  curtain_down do |*args|
    fire :remove_me
    input_manager.clear_hooks
  end

  helpers do
    def common_setup
      @stagehand = create_actor :stagehand
      @number_of_textures_created = 0
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

    # speed of tweens
    def rate
      0.10
    end

    def remove_actors
      @title.remove
      @textures.each {|t| t.remove }
    end

    def cycle
      @stagehand.fire :start_sliding
      @stagehand.fire :delete
      @stagehand.fire :introduce
    end

    def remove_texture_borders
      @textures.each {|t| t.border_enabled = false }
    end

  end

end
