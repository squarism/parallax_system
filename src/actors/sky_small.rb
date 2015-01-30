define_actor :sky_small do
  has_behaviors do 
    graphical tileable: true
  end

  behavior do
    setup do
      actor.has_attributes border:     Color::WHITE,
                           padding_h:  image_height_diff,
                           border_enabled: true
    end

    helpers do
      def image_height_diff
        if actor.image.height < actor.height
          (actor.height - actor.image.height) / 2
        else
          0
        end
      end
    end

  end


  view do
    draw do |target, x_off, y_off, z|
      x = actor.x + x_off - actor.width / 2
      y = actor.y + y_off - actor.height / 2


      actor.image.draw x, y + actor.padding_h, actor.layer

      if actor.border_enabled
        target.draw_box x,y, x+actor.width, y+actor.height, actor.border, actor.layer
      end
    end
  end


end
