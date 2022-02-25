@echo off 

ffmpeg -i %1 -filter_complex "split [a][b];[a] palettegen [p];[b][p] paletteuse" %~n1.compressed.gif