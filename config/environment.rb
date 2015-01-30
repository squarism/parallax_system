APP_ROOT = "#{File.join(File.dirname(__FILE__),"..")}/"

require 'yaml'
require 'gamebox'
require 'gamebox/constants'
require 'releasy'

Gamebox.configure do |config|
  config.config_path = APP_ROOT + "config/"
  config.data_path = APP_ROOT + "data/"
  config.music_path = APP_ROOT + "data/music/"
  config.sound_path = APP_ROOT + "data/sounds/"
  config.gfx_path = APP_ROOT + "data/graphics/"
  config.fonts_path = APP_ROOT + "data/fonts/"

  config.gb_config_path = GAMEBOX_PATH + "config/"
  config.gb_data_path = GAMEBOX_PATH + "data/"
  config.gb_music_path = GAMEBOX_PATH + "data/music/"
  config.gb_sound_path = GAMEBOX_PATH + "data/sounds/"
  config.gb_gfx_path = GAMEBOX_PATH + "data/graphics/"
  config.gb_fonts_path = GAMEBOX_PATH + "data/fonts/"

  config.default_font_name = "providence.ttf"

  config.stages = [:wireframe, :textured, :system, :final]
  config.game_name = "Parallax System Demo"
  # Not sure if this is needed, seems to make it a little better
  Gosu::enable_undocumented_retrofication
end


# --------------------------------------------------------
# Flickering fixes
Gosu::enable_undocumented_retrofication

# TODO make tileable an option on graphical behavior
# for now monkey patch it in
# see: http://www.libgosu.org/rdoc/file.Tileability.html
class ResourceManager
  def load_image(file_name)
    cached_img = @loaded_images[file_name]
    if cached_img.nil?
      begin
        full_name = Gamebox.configuration.gfx_path + file_name
        if ! File.exist? full_name
          #check global gamebox location
          full_name = Gamebox.configuration.gb_gfx_path + file_name
        end
        cached_img = Image.new(@window, full_name, true)
      rescue Exception => ex
        # log "Cannot load image #{file_name}", :warn
      end
      @loaded_images[file_name] = cached_img
    end
    cached_img
  end
end
# --------------------------------------------------------

[GAMEBOX_PATH, APP_ROOT, File.join(APP_ROOT,'src')].each{|path| $: << path }
require "gamebox_application"

require_all Dir.glob("{src,lib}/**/*.rb").reject{ |f| f.match("src/app.rb")}



