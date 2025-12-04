# EasyImageEdit

**公開準備中**

実験的なプロジェクトです。今のところ Edit 機能はありません。

Z-Image-Turbo(ZIT) を簡単に試せる環境です。  
**Geforce RTX 3060(VRAM 12GB) で `1024x1024, fp8_scaled, res_multitep, 4steps` の生成が `11秒` です。**  
**RAM 16GB, Geforce GTX 1660Ti(VRAM 6GB) 環境で動作しています。**

## インストール

1. インストール先フォルダを `C:/EasyImageEdit/` や `D:/EIE/` などの浅いパスに作成します。
2. [EasyImageEditInstaller.bat](https://github.com/Zuntan03/EasyImageEdit/raw/main/EasyImageEdit/EasyImageEditInstaller.bat?ver=0) を右クリックして `名前をつけてリンク先を保存...` で、インストール先フォルダに保存します。
	- 注意）リンクを開いてから `名前をつけて保存` すると、`*.bat` が `*.txt` になり実行できなくなります。
3. 保存したインストーラをダブルクリックで実行します。
	- **`発行元を確認できませんでした。このソフトウェアを実行しますか？` と表示されたら `実行` します。**
	- **`WindowsによってPCが保護されました` と表示されたら、`詳細表示` から `実行` します。**
	- **`Microsoft Visual C++ 2015-2022 Redistributable` のインストールで `このアプリがデバイスに変更を加えることを許可しますか？` と表示されたら `はい` とします。**

## 使い方

1. `ComfyUi.bat` で起動します。
	- `Press any key to continue . . .` で終了する場合は、NVIDIA グラフィックスドライバの更新で正常に動作する場合があります。
	- 画像生成中に `Error runnning sage attention` が表示される場合は、`ComfyUi_OldGpu.bat` で起動してください。
	- **[ 注意 ][ ComfyUI の罠 ][ 被害者多め ]**  
	**初回起動時にブラウザキャッシュにある過去のワークフローが開かれ、エラーになる場合があります。**  
	**エラーを無視してワークフローを閉じてください。**
2. 左端バーの `ワークフロー` から、`Easy/ZIT/ZIT-Comparison.json` ワークフローを開いて、`実行する` で画像を生成します。
	- 長いパスの `FileNotFoundError` が発生する場合は、`EasyEnv\EnableLongPaths.bat` を右クリックして `管理者として実行` してから Windows を再起動します。

- **`Update.bat` で EasyImageEdit を更新します。**
- **`Download\ZImageTurboComparison.bat` でデフォルトの `fp8_scaled` に加え、`bf16`, `DF11`, `GGUF` といった比較用の追加モデルをダウンロードします。**

### LoRA を使う

1. `ComfyUI_models/loras` に LoRA を保存します。
2. `LoRA 選択` ノードの `Add LoRA` で LoRA を追加します。
3. 追加した LoRA を右クリックして `Show Info` で `Trigger Words` などを確認できます。
4. ポジティブプロンプトに `Trigger Words` を入力して生成します。

- `DF11` は LoRA が効かない？ようなのでご注意ください。

## 最近の更新

### 2025/12/04

- `comfy.settings.json` のバージョンアップに対応し、グリッドスナップを有効にしました。
- 新規インストール時に `rgthree-comfy` のプログレスバーを無効化しました。
	- 公式のプログレスバーと機能が重複しているためです。
	- すでにインストール済みの場合は `ComfyUI\custom_nodes\rgthree-comfy\rgthree_config.json` を削除してから `Update.bat` すると、同様に無効化できます。
- 稀に黒画像が生成される問題に対処しました。

### 2025/12/03

- `ZIT-TextToImage` ワークフローでの `TypeError: VAEDecodeTiled.decode() missing 1 required positional argument: 'samples'` エラー修正。
- 特定の環境でパッチの適用に失敗する問題への対処。
	- `error: patch failed: nodes.py:333`

### 2025/12/02

- `ZIT-TextToImage` ワークフローを `Easy/ZIT/` に追加しました。
	- 実験的な機能として『プロンプト強化』『画像からのプロンプト生成』『ZIT によるアップスケール』を追加しています。
- カスタムノードに [Comfyui-Z-Image-Utilities](https://github.com/Koko-boya/Comfyui-Z-Image-Utilities/) と [ComfyUI-EulerDiscreteScheduler](https://github.com/erosDiffusion/ComfyUI-EulerDiscreteScheduler/) を追加しました。
	- 手元では `euler`, `simple`, `9step` の精度が高いです。

`Z-Image Prompt Enhancer` まわりでエラーが発生した場合は、`Manager` ボタン横の `Free model and node cache` をしてから再実行してみてください。

### 2025/11/30

- 公開しました。
- 次は高速化＆比較に対応したワークフローを用意しま~~す~~した。

DF11 の無劣化を確認  
![](https://raw.githubusercontent.com/wiki/Zuntan03/EasyImageEdit/Log/2511/Df11Lossless.webp)

## ライセンス

このリポジトリの内容は [Apache License 2.0](./LICENSE.txt) です。  
別途ライセンスファイルがあるフォルダ以下は、そのライセンスです。

```
   Copyright 2025 Zuntan

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
