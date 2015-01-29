class ParallaxSystem
  attr_accessor :rate
  attr_reader :actors

  def initialize(stage:, width:, height:, actor_name:, x:, y:, layer:)
    @width = width
    @height = height
    @origin_x = x
    @origin_y = y
    @layer = layer
    @actor_name = actor_name
    @stage = stage
    @rate = 0.10

    spawn_initial_actors
  end

  def spawn_initial_actors
    @actors = []
    @actors << @stage.create_actor(@actor_name, x:left_spawn_point,  y:@origin_y, width: @width, height: @height, layer: @layer)
    @actors << @stage.create_actor(@actor_name, x:@origin_x,         y:@origin_y, width: @width, height: @height, layer: @layer)
    @actors << @stage.create_actor(@actor_name, x:right_spawn_point, y:@origin_y, width: @width, height: @height, layer: @layer)
  end

  def left_spawn_point
    @origin_x - @width
  end

  def right_spawn_point
    @origin_x + @width
  end

  def start(tween_manager)
    @actors.each do |actor|
      start_actor(tween_manager, actor)
    end
  end

  def start_actor(tween_manager, actor)
    destination_x = actor.x - @width * 3.0
    distance_x = (actor.x - destination_x).abs
    @stage.tween_manager.tween_properties actor,
    {x: destination_x, y:actor.y}, distance_x / @rate, Tween::Linear
  end

  def respawn_parallax_actor
    spawn_x = @actors.first.x + @width * 3.0
    respawn = @actors.shift
    respawn.x = spawn_x
    respawn
  end

  # when first texture is halfway off the screen, spawn another one
  def check_for_respawn(tween_manager)
    if @actors.first.x < @origin_x - @width
      actor = respawn_parallax_actor
      start_actor(tween_manager, actor)
      @actors << actor
    end

    if @actors.first.x <= -(@width)
      dead = @actors.shift
      dead.remove
    end
  end

end
