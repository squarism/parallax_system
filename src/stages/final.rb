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
    sky.start tween_manager

    director.when :update do |time|
      sky.check_for_respawn(tween_manager)
    end

    @stagehand.when(:remove_borders) do
      @border_enabled = false
      sky.each do |actor|
        actor.border_enabled = @border_enabled
      end
    end

    input_manager.reg :down, K_SPACE do
      @stagehand.progression_counter += 1

      case @stagehand.progression_counter
      when 1
        @stagehand.fire :remove_borders
      else
        fire :next_stage
      end
    end

  end

end