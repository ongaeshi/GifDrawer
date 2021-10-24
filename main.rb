require "clip"

SCALE = 1
$gif_reader = nil

App.window_size(320, 180)
Drawer.background("gray")

script do |root|
  if $gif_reader
    gif = root.gif($gif_reader)
    gif.scale(SCALE, SCALE)
    gif.play
  end
end

App.run do
  if DragDrop.has_new_file_paths
    gif_path = DragDrop.get_dropped_file_path

    if gif_path.end_with?(".gif")
      $gif_reader = GifReader.new(gif_path)
      App.window_size($gif_reader.width * SCALE, $gif_reader.height * SCALE)
      App.end_time = $gif_reader.duration
      App.reset
    end
  end
end
