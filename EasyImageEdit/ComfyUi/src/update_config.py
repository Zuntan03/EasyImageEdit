"""ComfyUI設定ファイル更新スクリプト

ComfyUIの設定ファイル `comfy.settings.json` をバージョン管理して更新する。

- 設定ファイルが存在しない場合、空の設定ファイルを新規作成
- 設定ファイル読み込み後、バージョンに基づいて更新関数を順次適用
- 既存のユーザー設定は保持（更新関数で明示的に変更する項目のみ上書き）
"""

import json
import sys
from pathlib import Path


class ComfyUiConfig:
    """ComfyUI設定ファイルを管理するクラス。

    Attributes
    ----------
    DEBUG_MODE : bool
        Trueの場合、毎回バージョンを初期化して更新処理をテストする
    VERSION_KEY : str
        設定ファイル内のバージョン管理キー
    INITIAL_VERSION : str
        初期バージョン（設定ファイルにバージョンキーがない場合）
    """

    DEBUG_MODE = True
    VERSION_KEY = "easy_image_edit_config_version"
    INITIAL_VERSION = "0.0.0"

    def __init__(self, cfg_path: str) -> None:
        """設定ファイルを読み込み、必要に応じて更新する。

        Parameters
        ----------
        cfg_path : str
            設定ファイルのパス
        """
        self.updaters = {
            "0.0.0": self._update_0_0_0,
        }

        cfg_path = Path(cfg_path)
        cfg_path.parent.mkdir(parents=True, exist_ok=True)

        if not cfg_path.exists():
            with open(cfg_path, "w", encoding="utf-8") as f:
                json.dump({}, f)

        with open(cfg_path, "r+", encoding="utf-8") as f:
            cfg = json.load(f)

            if self.VERSION_KEY not in cfg:
                cfg[self.VERSION_KEY] = self.INITIAL_VERSION

            if self.DEBUG_MODE:
                cfg[self.VERSION_KEY] = self.INITIAL_VERSION
                cfg["Comfy.DevMode"] = True

            if self._apply_updates(cfg):
                f.seek(0)
                json.dump(cfg, f, indent=4)
                f.truncate()

    def _apply_updates(self, cfg: dict) -> bool:
        """バージョンに応じた更新を順次適用する。

        Parameters
        ----------
        cfg : dict
            設定辞書

        Returns
        -------
        bool
            更新が行われた場合True
        """
        version = cfg[self.VERSION_KEY]
        if version not in self.updaters:
            return False

        self.updaters[version](cfg)
        self._apply_updates(cfg)
        return True

    def _update_0_0_0(self, cfg: dict) -> None:
        """バージョン0.0.0から0.1.0への更新。

        Parameters
        ----------
        cfg : dict
            設定辞書
        """
        cfg[self.VERSION_KEY] = "0.1.0"
        cfg["Comfy.Workflow.SortNodeIdOnSave"] = True
        cfg["pysssss.SnapToGrid"] = True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python update_config.py <config_file_path>")
        sys.exit(1)

    ComfyUiConfig(sys.argv[1])
