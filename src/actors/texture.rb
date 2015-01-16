define_actor :texture do
  has_behavior :positioned
  has_behavior :layered

  behavior do
    requires :font_style_factory
    setup do
      actor.has_attributes text:      "Default Text",
                           font_size: Gamebox.configuration.default_font_size,
                           font_name: Gamebox.configuration.default_font_name,
                           color:     Color.new(255, 255, 255, 255),
                           fill:      Color::BLUE,
                           border:    Color::WHITE,
                           padding:   10

      font_style = font_style_factory.build actor.font_name, actor.font_size, actor.color
      actor.has_attributes font_style: font_style
    end
  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off - actor.width / 2
      y = actor.y + y_off - actor.height / 2
      target.draw_box x,y, x+actor.width, y+actor.height, actor.border, actor.layer
      target.fill x,y, x+actor.width-1, y+actor.height-1, actor.fill, actor.layer

      actor.font_style.font.draw actor.text,
        x + actor.padding, y + actor.padding,
        actor.layer, actor.font_style.x_scale,
        actor.font_style.y_scale, actor.color

    end
  end

end
