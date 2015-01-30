# Seamless Cloud Patterns by bheware
# http://seamlesstextures.deviantart.com/art/Sky-texture-pack-97378275

define_actor :sky do
  has_behaviors do 
    graphical tileable: true
  end
  # TODO: needs bordered behavior

  behavior do
    setup do
      actor.has_attributes border:     Color::WHITE,
                           border_enabled: false
    end
  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off
      y = actor.y + y_off

      actor.image.draw x, y, actor.layer

      if actor.border_enabled
        target.draw_box x,y, x+actor.width, y+actor.height, actor.border, actor.layer
      end
    end
  end


end
