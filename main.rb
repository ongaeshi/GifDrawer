CLIP_MANAGER_IS_STOP = true # 起動時に再生停止
require "clip"

SCALE = 1
gif_reader = nil

App.window_size(320, 180)

def draw_mosaic(clip, color1, color2)
  Drawer.background(color1)

  (0..(App.width/40)).each do |x|
    (0..(App.height/40)).each do |y|
      if (x + y) % 2 == 1
        clip.rect(x * 40, y * 40, 40, 40, color: color2)
      end
    end
  end
end

script do |root|
  draw_mosaic(root, "gray", "silver")

  if gif_reader
    gif = root.gif(gif_reader)
    gif.scale(SCALE, SCALE)
    gif.play
  end
end

App.run do
  if DragDrop.has_new_file_paths
    gif_path = DragDrop.get_dropped_file_path

    if gif_path.end_with?(".gif")
      gif_reader = GifReader.new(gif_path)
      App.window_size(gif_reader.width * SCALE, gif_reader.height * SCALE)
      App.end_time = gif_reader.duration
      App.reset
      App.is_stop = false
    end
  end

  if MouseL.pressed
    puts "#{App.time}, #{Cursor.pos.x}, #{Cursor.pos.y}"
  end
end
