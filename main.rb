CLIP_MANAGER_IS_STOP = true # 起動時に再生停止
require "clip"

DEFAULT_END_TIME = 30
SCALE = 1
gif_reader = nil
texture = nil
root_script = nil
line_with_times = []
dynamic_texture = nil

# ---
class LineWithTime
  attr_reader :time, :point, :delta

  def initialize(time, point, delta)
    @time = time
    @point = point
    @delta = delta
  end

  def draw(image)
    Drawer.line_to_image(
      image,
      point.x, point.y,
      point.x - delta.x, point.y - delta.y,
      4,
      "black" # "orange"
    )
  end
end

def draw_mosaic(clip, color1, color2)
  Drawer.background(color1)

  (0..(App.width / 40)).each do |x|
    (0..(App.height / 40)).each do |y|
      if (x + y) % 2 == 1
        clip.rect(x * 40, y * 40, 40, 40, color: color2)
      end
    end
  end
end

# ---
App.window_size(640, 360)
App.end_time = DEFAULT_END_TIME

script do |root|
  current_index = 0
  root_script = root

  # draw_mosaic(root, "gray", "silver")
  Drawer.background("silver")

  if gif_reader
    gif = root.gif(gif_reader)
    gif.scale(SCALE, SCALE)
    gif.play
  elsif texture
    root.texture(texture, 0, 0)
  end

  dynamic_texture = root.dynamic_texture(App.width, App.height, [255, 255, 255, 0])

  loop do
    (current_index...line_with_times.count).each do |i|
      line = line_with_times[i]
      break if line.time > App.time
      line.draw(dynamic_texture.image)
      current_index += 1
    end
    dynamic_texture.image_to_texture
    root.wait_delta
  end
end

App.run do
  if DragDrop.has_new_file_paths
    file_path = DragDrop.get_dropped_file_path

    gif_reader = texture = nil
    line_with_times = []

    if file_path.end_with?(".gif")
      gif_reader = GifReader.new(file_path)
      App.window_size(gif_reader.width * SCALE, gif_reader.height * SCALE)
      App.end_time = gif_reader.duration > 0 ? gif_reader.duration : DEFAULT_END_TIME
    else
      texture = Texture.new(file_path)
      App.window_size(texture.width * SCALE, texture.height * SCALE)
      App.end_time = DEFAULT_END_TIME
    end

    App.reset
    App.is_stop = false
  end

  if dynamic_texture && MouseL.pressed
    line = LineWithTime.new(App.time, Cursor.pos, MouseL.down ? Vec2.new(0,0) : Cursor.delta)
    line.draw(dynamic_texture.image)  # TODO: 書いているときだけ多重描画されている。半透明だと問題が起きる。
    line_with_times.push(line)
    line_with_times = line_with_times.sort_by { |e| e.time }
    dynamic_texture.image_to_texture
  end
end
