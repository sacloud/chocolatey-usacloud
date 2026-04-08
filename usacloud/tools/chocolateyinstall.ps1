$ErrorActionPreference = 'Stop';

$packageName  = $env:ChocolateyPackageName;
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)";
$softwareName = 'usacloud*';
$url32        = 'https://github.com/sacloud/usacloud/releases/download/__VERSION__/usacloud_windows-386.zip';
$url64        = 'https://github.com/sacloud/usacloud/releases/download/__VERSION__/usacloud_windows-amd64.zip';
$hashType     = 'sha512';
$hash32       = '__HASH32__';
$hash64       = '__HASH64__';

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url32
  url64bit      = $url64
  softwareName  = $softwareName
  checksum      = $hash32
  checksumType  = $hashType
  checksum64    = $hash64
  checksumType64= $hashType
}

# https://chocolatey.org/docs/helpers-install-chocolatey-zip-package
Install-ChocolateyZipPackage @packageArgs

# Setup PowerShell tab completion
$completionScriptName = 'Usacloud.PowerShell_profile.ps1'
$profileDir = Split-Path -Parent $PROFILE
$completionScriptPath = Join-Path $profileDir $completionScriptName
$dotSourceLine = ". `"$completionScriptPath`""

try {
  $usacloudPath = Join-Path $toolsDir 'usacloud.exe'
  $completionContent = & $usacloudPath completion powershell
  if ($completionContent) {
    if (-not (Test-Path $profileDir)) {
      New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    $completionContent | Out-File -FilePath $completionScriptPath -Encoding utf8 -Force
    Write-Host "Tab completion script created at: $completionScriptPath"
    Write-Host "タブ補完のスクリプトを作成しました: $completionScriptPath"

    if (-not (Test-Path $PROFILE)) {
      New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if (-not $profileContent -or -not $profileContent.Contains($dotSourceLine)) {
      Add-Content -Path $PROFILE -Value "`n$dotSourceLine"
      Write-Host "Tab completion registered in: $PROFILE"
      Write-Host "タブ補完を登録しました: $PROFILE"
    }
  }
} catch {
  Write-Warning "Tab completion setup failed: $_"
  Write-Warning "usacloud itself was installed successfully. Tab completion can be set up manually."
  Write-Warning "タブ補完のセットアップ時にエラーが発生しました: $_"
  Write-Warning "usacloud本体のインストールは完了しています！"
  Write-Warning "タブ補完は手動で設定が可能です。"
}
