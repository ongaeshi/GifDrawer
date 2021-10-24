require "clip"

current_path = nil
scale = 1

App.window_size(320, 180)
Drawer.background("gray")

# script do |root|
#   loop do
#     if !$dropped_file_path.nil?
#       current_path = $dropped_file_path
#       $dropped_file_path = nil
#       gif_reader = GifReader.new(current_path)
#       gif = root.gif(gif_reader)
#       App.window_size(gif_reader.width * scale, gif_reader.height * scale)
#       App.end_time = gif_reader.duration
#     end

#     root.wait_delta
#   end
# end

# if current_path.nil? && !$dropped_file_path.nil?
#   current_path = $dropped_file_path
#   gif = GifReader.new(current_path)
#   App.window_size(gif.width * scale, gif.height * scale)
#   App.end_time = gif.duration + 0.5

#   script do |root|
#     p gif
#     g = root.gif(gif)
#     g.scale(scale, scale)
#     g.play
#   end
# end

App.run do
  if DragDrop.has_new_file_paths
    $dropped_file_path = DragDrop.get_dropped_file_path
    p $dropped_file_path
  end
end
