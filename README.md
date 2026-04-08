# chocolatey-usacloud

[usacloud](https://github.com/sacloud/usacloud)（さくらのクラウドCLIクライアント）の[Chocolatey](https://community.chocolatey.org/packages/usacloud)パッケージです。

[![Chocolatey Package](https://github.com/sacloud/chocolatey-usacloud/actions/workflows/chocolatey.yml/badge.svg)](https://github.com/sacloud/chocolatey-usacloud/actions/workflows/chocolatey.yml)

## インストール

```powershell
choco install usacloud
```

### アップデート

```powershell
choco upgrade usacloud
```

### アンインストール

```powershell
choco uninstall usacloud
```

## CI/CD

GitHub Actionsによる自動ビルド・配信を行っています。

### 処理の流れ

1. GitHub APIから[sacloud/usacloud](https://github.com/sacloud/usacloud)の最新リリースバージョンを取得
2. Chocolatey上の登録済みバージョン（審査中を含む）と比較し、同一であればスキップ
3. Windows 32bit/64bitのzipをダウンロードしSHA512ハッシュを算出
4. テンプレートファイルのプレースホルダーを実際の値に置換
5. `choco pack`で`.nupkg`を生成
6. ローカルインストールテスト（`choco install` → `usacloud --version` → `choco uninstall`）
7. テスト成功後、Chocolateyへ自動push

### 定時ビルド

GitHub Actionsのスケジュール実行により、毎日UTC 0:00（JST 9:00）にusacloudの新バージョンを確認しています。

新バージョンが検出された場合のみビルド・配信が実行されます。

## ローカルビルド

手動でパッケージをビルド・テストする場合の手順です。

```powershell
# 最新バージョンの取得
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/sacloud/usacloud/releases/latest"
$version = $release.tag_name -replace "^v", ""

# zipのダウンロードとハッシュ算出
$url32 = "https://github.com/sacloud/usacloud/releases/download/v${version}/usacloud_windows-386.zip"
$url64 = "https://github.com/sacloud/usacloud/releases/download/v${version}/usacloud_windows-amd64.zip"
Invoke-WebRequest $url32 -OutFile .\x32.zip
Invoke-WebRequest $url64 -OutFile .\x64.zip
$hash32 = (Get-FileHash .\x32.zip -Algorithm SHA512).Hash
$hash64 = (Get-FileHash .\x64.zip -Algorithm SHA512).Hash

# プレースホルダーの置換
cd usacloud
(Get-Content '.\usacloud.nuspec' -Raw).Replace("__VERSION__", $version) | Out-File '.\usacloud.nuspec' -Encoding utf8
(Get-Content '.\tools\chocolateyinstall.ps1' -Raw).Replace("__VERSION__", "v$version").Replace("__HASH32__", $hash32).Replace("__HASH64__", $hash64) | Out-File '.\tools\chocolateyinstall.ps1' -Encoding utf8

# パッケージ作成とテスト
choco pack
choco install usacloud -s .\ -f
usacloud --version
choco uninstall usacloud
```

> **注意**: テンプレートファイルのプレースホルダー（`__VERSION__`, `__HASH32__`, `__HASH64__`）を直接書き換えてコミットしないでください。これらはCI時に動的に置換されます。

## リポジトリ構成

| ファイル                                 | 説明                       |
|------------------------------------------|----------------------------|
| `usacloud/usacloud.nuspec`               | Chocolateyパッケージ定義   |
| `usacloud/tools/chocolateyinstall.ps1`   | インストールスクリプト     |
| `usacloud/tools/chocolateyuninstall.ps1` | アンインストールスクリプト |
| `.github/workflows/chocolatey.yml`       | GitHub Actions CI/CD設定   |

## 関連リンク

- [usacloud](https://github.com/sacloud/usacloud) - さくらのクラウドCLIクライアント本体
- [usacloudドキュメント](https://docs.usacloud.jp/usacloud/)
- [Chocolateyパッケージページ](https://community.chocolatey.org/packages/usacloud)

## ライセンス

[MIT License](LICENSE)
