# 調整用パラメータ

# ペンの色
# PEN_COLOR = "navy"
# PEN_COLOR = "blue"
# PEN_COLOR = "aqua"
# PEN_COLOR = "teal"
# PEN_COLOR = "olive"
# PEN_COLOR = "green"
# PEN_COLOR = "lime"
# PEN_COLOR = "yellow"
# PEN_COLOR = "orange"
PEN_COLOR = "red"
# PEN_COLOR = "fuchsia"
# PEN_COLOR = "purple"
# PEN_COLOR = "maroon"
# PEN_COLOR = "white"
# PEN_COLOR = "silver"
# PEN_COLOR = "gray"
# PEN_COLOR = "black"

# ペンの太さ
PEN_THICKNESS = 2

# 消しゴムの太さ
ERASER_THICKNESS = 32

# gifアニメが未設定のときの終了時間
DEFAULT_END_TIME = 5

# スローボタン(🐢)を押したときの再生レート(小さいほど遅くなる)
CLIP_MANAGER_SLOW_DELTA_RATE = 0.25

# ---
CLIP_MANAGER_IS_STOP = true # 起動時に再生停止
require "clip"

SCALE = 1
gif_reader = nil
texture = nil
root_script = nil
line_with_times = []
dynamic_texture = nil

# ---
class LineWithTime
  attr_reader :time, :point, :delta

  def initialize(time, point, delta, pen_color, is_eraser = false)
    @time = time
    @point = point
    @delta = delta
    @pen_color = pen_color
    @is_eraser = is_eraser
  end

  def draw(image)
    Drawer.line_to_image(
      image,
      point.x, point.y,
      point.x - delta.x, point.y - delta.y,
      thickness,
      color
    )
  end

  def thickness
    @is_eraser ? ERASER_THICKNESS : PEN_THICKNESS
  end

  def color
    @is_eraser ? [255, 255, 255, 0] : @pen_color
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

def draw_pen_rect(x, y, color)
  length = 30
  Drawer.rect(x, y, length, length, PEN_COLORS[@pen_color_index])
  Drawer.rect(x, y, length, length, "black", 1)
end

# ---
App.window_size(640, 360)
App.end_time = DEFAULT_END_TIME

script do |root|
  current_index = 0
  root_script = root

  # draw_mosaic(root, "gray", "silver")
  # Drawer.background("silver")
  Drawer.background([243, 245, 250])

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

PEN_COLORS = ["red", "blue", "green", "black"]
@pen_color_index = 0

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

  if KeyC.down
    @pen_color_index += 1
    @pen_color_index = 0 if @pen_color_index >= PEN_COLORS.length
  end

  draw_pen_rect(100, 300, PEN_COLORS[@pen_color_index])

  if dynamic_texture
    if MouseR.pressed || MouseL.pressed
      is_eraser = MouseR.pressed
      if Cursor.delta.x != 0 || Cursor.delta.y != 0 || MouseL.down || MouseR.down
        line = LineWithTime.new(
          App.time,
          Cursor.pos,
          MouseL.down ? Vec2.new(0, 0) : Cursor.delta,
          PEN_COLORS[@pen_color_index],
          is_eraser
        )
        line.draw(dynamic_texture.image) # TODO: 書いているときだけ多重描画されている。半透明だと問題が起きる。
        index = line_with_times.bsearch_index { |e| line.time < e.time }
        if index.nil?
          line_with_times.push(line)
        else
          line_with_times.insert(index, line)
        end
        dynamic_texture.image_to_texture
      end
    end
  end
end
