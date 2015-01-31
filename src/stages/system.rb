# this stage is a working parallax system but zoomed out for demo purposes.
define_stage :system do
  requires :tween_manager

  curtain_up do
    @title = create_actor :label, x:center_x - 260, y:25, text:"ParallaxSystem Object", font_size: 64
    @stagehand = create_actor :stagehand
    @border_enabled = false
    center_x = viewport.width / 2
    center_y = viewport.height / 2
    fake_viewport_width = viewport.width / 4
    fake_viewport_height = viewport.height / 4
    @fake_viewport = create_actor :fake_viewport,
      x:center_x, y:center_y, width:fake_viewport_width+2, height:fake_viewport_height+2

    # gamebox doesn't scale images for you with width and height
    # so I'm just hardcoding the width to the save of the screen
    # be sure to size your images beforehand
    sky = ParallaxSystem.new(stage:self,
      width:fake_viewport_width, height:fake_viewport_height,
      actor_name: :sky_small, x:center_x, y:center_y, layer:1
    )
    sky.start tween_manager

    director.when :update do |time|
      sky.check_for_respawn(tween_manager)
    end

    @stagehand.when(:remove_borders) do
      @border_enabled = false
      sky.actors.each do |actor|
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

  helpers do
    def center_x
      viewport.width / 2
    end
  end


end