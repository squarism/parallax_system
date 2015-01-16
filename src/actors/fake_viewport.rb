define_actor :fake_viewport do
  has_behavior :positioned
  has_behavior :layered

  has_attributes fill: Color.new(20, 255, 255, 255)

  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off - actor.width / 2
      y = actor.y + y_off - actor.height / 2
      target.draw_box x, y, x + actor.width, y + actor.height, Color::WHITE, actor.layer
      target.fill x, y, x + actor.width, y + actor.height, actor.fill, actor.layer
    end
  end

end
