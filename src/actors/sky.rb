define_actor :sky do
  has_behavior :positioned, :layered, :graphical
  # TODO: needs bordered behavior

  behavior do
    setup do
      actor.has_attributes border:     Color::WHITE,
                           border_enabled: false
    end
  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off# - actor.width / 2
      y = actor.y + y_off# - actor.height / 2

      actor.image.draw x, y, actor.layer

      if actor.border_enabled
        target.draw_box x,y, x+actor.width, y+actor.height, actor.border, actor.layer
      end
    end
  end


end
