CLIP_MANAGER_IS_STOP = true # 起動時に再生停止
require "clip"

SCALE = 1
gif_reader = nil
root_script = nil
line_with_times = []

# ---
class LineWithTime
  attr_reader :time, :point, :delta

  def initialize(time, point, delta)
    @time = time
    @point = point
    @delta = delta
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
App.window_size(320, 180)

script do |root|
  current_index = 0
  root_script = root

  draw_mosaic(root, "gray", "silver")

  if gif_reader
    gif = root.gif(gif_reader)
    gif.scale(SCALE, SCALE)
    gif.play
  end

  loop do
    (current_index...line_with_times.count).each do |i|
      e = line_with_times[i]
      if App.time >= e.time
        root.line(
          e.point.x, e.point.y,
          e.point.x - e.delta.x, e.point.y - e.delta.y,
          thickness: 8,
          color: "orange"
        )
        current_index += 1
      end
    end

    root.wait_delta
  end
end

App.run do
  if DragDrop.has_new_file_paths
    gif_path = DragDrop.get_dropped_file_path

    if gif_path.end_with?(".gif")
      gif_reader = GifReader.new(gif_path)
      line_with_times = []
      App.window_size(gif_reader.width * SCALE, gif_reader.height * SCALE)
      App.end_time = gif_reader.duration
      App.reset
      App.is_stop = false
    end
  end

  if MouseL.pressed
    e = LineWithTime.new(App.time, Cursor.pos, MouseL.down ? Vec2.new(0,0) : Cursor.delta)

    root_script.line(
      e.point.x, e.point.y,
      e.point.x - e.delta.x, e.point.y - e.delta.y,
      thickness: 8,
      color: "orange"
    )

    line_with_times.push(e)
    line_with_times = line_with_times.sort_by { |e| e.time }
  end
end
