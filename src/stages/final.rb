# this stage is a working parallax system zoomed in for the full illusion

define_stage :final do
  requires :tween_manager

  curtain_up do
    @stagehand = create_actor :stagehand
    @border_enabled = false
    center_x = viewport.width / 2
    center_y = viewport.height / 2

    # gamebox doesn't scale images for you with width and height
    # so I'm just hardcoding the width to the save of the screen
    # be sure to size your images beforehand
    sky = ParallaxSystem.new(stage:self,
      width:viewport.width, height:viewport.height,
      actor_name: :sky, x:0, y:0, layer:1
    )
    sky.rate = 0.0050
    sky.start tween_manager

    # scopes
    ground = nil
    mountains = nil
    water = nil

    director.when :update do |time|
      sky.check_for_respawn(tween_manager)
      ground.check_for_respawn(tween_manager) if ground
      mountains.check_for_respawn(tween_manager) if mountains
      water.check_for_respawn(tween_manager) if water
    end

    input_manager.reg :down, K_SPACE do
      @stagehand.progression_counter += 1

      case @stagehand.progression_counter
      when 1
        mountains = ParallaxSystem.new(stage:self,
          width:viewport.width, height:viewport.height,
          actor_name: :mountain, x:0, y:220, layer:2
        )
        mountains.rate = 0.0100
        mountains.start tween_manager
      when 2
        ground = ParallaxSystem.new(stage:self,
          width:viewport.width, height:viewport.height,
          actor_name: :ground, x:0, y:295, layer:5
        )
        ground.rate = 0.0150
        ground.start tween_manager
      when 3
        water = ParallaxSystem.new(stage:self,
          width:viewport.width, height:viewport.height,
          actor_name: :water, x:0, y:620, layer:6
        )
        water.rate = 0.0280
        water.start tween_manager
      else
        fire :next_stage
      end
    end

  end

end