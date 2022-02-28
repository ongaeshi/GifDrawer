# GifDrawer
GIFアニメーションにお絵描き。

## インストール
このレポジトリをgit cloneすればすぐに使えます。  
または[tags](https://github.com/ongaeshi/GifDrawer/tags)から最新をダウンロード。

```
$ git clone https://github.com/ongaeshi/GifDrawer.git
```

## 使い方
### 1. 線を書く
マウス左クリックで線を書く。

![draw-line.gif](resource/draw-line.gif)

### 2. 消しゴム
マウス右クリックで消しゴム。

![](resource/gif-drawer-eraser.gif)

### 3. 書いた線がアニメーションに
コマ送りを使うとアニメーションが作りやすい。

![](resource/gif-drawer-frame-by-frame.gif)

完成品。

![](resource/gif-drawer-hello.gif)

### 4. gifアニメや画像を背景にする
ドラッグ＆ドロップ

### 5. ペンの色や太さの変更

### 6. アニメーションの保存
gifアニメで保存できます

### 7. 作成したアニメーションの圧縮
ffmpegが必要です

## キーボードショートカット
|  キー  | 説明  |
| ---- | ---- |
|  SPACE    |  PLAY/STOP  |
|  →        |  TIME++  |
|  Ctrl + → |  TIME = end_time  |
|  ←        |  TIME--   |
|  Ctrl + ← |  TIME = 0  |
|  C        |  CHANGE COLOR  |
|  T        |  CHANGE THICKNESS  |
|  S        | SLOW PLAY |
|  F10      | LOOP TOGGLE |
|  F11      | UI TOGGLE |
