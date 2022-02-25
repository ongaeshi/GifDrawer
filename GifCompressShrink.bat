@echo off 

ffmpeg -i %1 -filter_complex "scale=640:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" %~n1.compshrinked.gif