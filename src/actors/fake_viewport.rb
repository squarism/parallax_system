define_actor :fake_viewport do
  has_behavior :positioned
  has_behavior :layered
  # TODO: needs bordered behavior


  behavior do
    setup do
      actor.has_attributes border:         Color::WHITE,
                           border_enabled: true,
                           fill:           Color.new(20, 255, 255, 255)
    end
  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off - actor.width / 2
      y = actor.y + y_off - actor.height / 2

      if actor.border_enabled
        target.draw_box x, y, x + actor.width, y + actor.height, actor.border, actor.layer
      end

      target.fill x, y, x + actor.width, y + actor.height, actor.fill, actor.layer
    end
  end

end
