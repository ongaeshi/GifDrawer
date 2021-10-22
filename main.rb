require "clip"

gif = GifReader.new("C:/Users/ongaeshi/Code/GifDrawer/resource/hello3.gif")
scale = 1

font = Font.new(40)

App.window_size(gif.width * scale, gif.height * scale)
App.end_time = gif.duration + 0.5

# script do
#   Drawer.background("gray")
# end

script do |root|
  g = root.gif(gif)
  g.scale(scale, scale)
  g.play
  root.wait 1
  g.stop
  root.text(font, 99, 229, color: "black", text: "LGTM")
  root.wait 0.5
  g.play
end

App.run
