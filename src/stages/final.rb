def spawn_point(parallax_system)
  parallax_system.last.x + viewport.width
end

# gamebox doesn't scale images for you with width and height
# so I'm just hardcoding the width to the save of the screen
# be sure to size your images beforehand
def parallax_system(actor_name, x, y, layer)
  system = []
  system << create_actor(actor_name, x:x, y:y,
    width: viewport.width, height: viewport.height,
    layer: layer)

  system << create_actor(actor_name, x:spawn_point(system) - 1.0, y:y,
    width: viewport.width, height: viewport.height,
    layer: layer)
end

def start_parallax_system(system, rate)
  system.each do |actor|
    start_parallax_actor(actor, rate)
  end
end

def start_parallax_actor(actor, rate)
  destination_x = actor.x - viewport.width * 3.0
  distance_x = (actor.x - destination_x).abs
  tween_manager.tween_properties actor,
    {x: destination_x, y:actor.y}, distance_x / rate, Tween::Linear
end

def spawn_parallax_actor(actor_name, system, layer)
  spawn_x = system.first.x + (viewport.width * 2.0)
  a = create_actor(actor_name, x:spawn_x, y:system.first.y, layer: layer)
  a.border_enabled = @border_enabled
  a
end

# when first texture is halfway off the screen, spawn #3
def respawn_parallax(actor_name, system, rate, layer)
  if system.length < 3 && system.first.x < viewport.width / 2
    actor = spawn_parallax_actor(actor_name, system, layer)
    start_parallax_actor(actor, rate)
    system << actor
  end

  if system.first.x <= -viewport.width
    dead = system.shift
    dead.remove
  end
end

def sky_rate
  0.25
end

define_stage :final do
  requires :tween_manager

  curtain_up do
    @stagehand = create_actor :stagehand
    @border_enabled = false

    sky = parallax_system(:sky, -25.0, 0.0, 1)
    sky_system = start_parallax_system sky, sky_rate

    director.when :update do |time|
      respawn_parallax(:sky, sky_system, sky_rate, 1)
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