# EasyImageEdit

**公開準備中**

実験的なプロジェクトです。今のところ Edit 機能はありません。

Z-Image-Turbo(ZIT) を簡単に試せる環境です。

## インストール

NVIDIA グラフィックスドライバを更新してください。

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
	- **[ 注意 ][ ComfyUI の罠 ][ 被害者多め ]**  
	**初回起動時にブラウザキャッシュにある過去のワークフローが開かれ、エラーになる場合があります。**  
	**エラーを無視してワークフローを閉じてください。**
2. 左端バーの `ワークフロー` から、`Easy/ZIT/Slow-ComfyUI_ZIT_Template.json` ワークフローを開いて、`実行する` で画像を生成します。

- **`Update.bat` で EasyImageEdit を更新します。**
- **`Download\ZImageTurboComparison.bat` でデフォルトの `fp8_scaled` に加え、`bf16`, `DF11`, `GGUF` といった比較用の追加モデルをダウンロードします。**

## 最近の更新

### 2025/11/30

- 公開しました。
- 次は高速化＆比較に対応したワークフローを用意します。
- `DF11` は LoRA が効かない？ようなのでご注意ください。

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
