define_actor :black do
  has_behavior :positioned
  has_behavior :layered

  behavior do
    setup do
      actor.has_attributes color:   Color.new(255, 0, 0, 0),
                           alpha:   255
    end
  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off - actor.width / 2
      y = actor.y + y_off - actor.height / 2

      color = actor.color
      color.alpha = actor.alpha
      target.fill x, y, x+actor.width-1, y+actor.height-1, color, actor.layer
    end
  end

end
