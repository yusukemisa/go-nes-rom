# go-nes-rom

NES ROM を置いておくリポジトリです。増やすときは `roms/` に足します。

最初の ROM は `roms/yusuke.nes` です。黒一色の画面に、白い文字 `Yusuke Misawa` だけを出します。

iNES ヘッダは [go-nes-by-pstack](https://github.com/yusukemisa/go-nes-by-pstack) の `testdata/nestest.nes` と同じです。

- シグネチャ `NES\x1A`
- PRG 1 ページ（16KB、NROM-128）
- CHR 1 ページ（8KB）
- Flags 6、Flags 7、残りのヘッダは 0（マッパー 0、水平ミラー、トレーナーなし）

## ビルド

[cc65](https://cc65.github.io/) の `ca65` と `ld65` が PATH にあること。

```
make
```

`roms/yusuke.nes` を上書きします。ソースは `src/yusuke.s`、配置は `src/nes.cfg` です。

## go-nes-by-pstack で動かす

[go-nes-by-pstack](https://github.com/yusukemisa/go-nes-by-pstack) をクローンして、そのディレクトリで ROM のパスを渡します。ウィンドウを開きます。Z が A、X が B、矢印が十字キーです。この ROM は入力を使いません。

```
go run ./cmd/nes path/to/go-nes-rom/roms/yusuke.nes
```

画面を出さず `frame.ppm` を書くときは `-ppm` です。パレットとネームテーブルを書いてから描画するので、フレーム数は 8 くらいにしてください。

```
go run ./cmd/nes -ppm path/to/go-nes-rom/roms/yusuke.nes 8
```
