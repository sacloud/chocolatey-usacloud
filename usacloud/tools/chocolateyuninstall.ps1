$ErrorActionPreference = 'Stop';

$packageName = $env:ChocolateyPackageName;

Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'usacloud_windows-386.zip'
Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'usacloud_windows-amd64.zip'

# Remove PowerShell tab completion
$completionScriptName = 'Usacloud.PowerShell_profile.ps1'
$profileDir = Split-Path -Parent $PROFILE
$completionScriptPath = Join-Path $profileDir $completionScriptName
$dotSourceLine = ". `"$completionScriptPath`""

try {
  if (Test-Path $completionScriptPath) {
    Remove-Item -Path $completionScriptPath -Force
    Write-Host "Tab completion script removed: $completionScriptPath"
    Write-Host "タブ補完スクリプトを削除しました: $completionScriptPath"
  }
  if (Test-Path $PROFILE) {
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($profileContent -and $profileContent.Contains($dotSourceLine)) {
      $profileContent = $profileContent.Replace($dotSourceLine, '').TrimEnd()
      $profileContent | Out-File -FilePath $PROFILE -Encoding utf8 -Force
      Write-Host "Tab completion removed from: $PROFILE"
      Write-Host "タブ補完を削除しました: $PROFILE"
    }
  }
} catch {
  Write-Warning "Tab completion cleanup failed: $_"
  Write-Warning "You may need to manually remove '$dotSourceLine' from $PROFILE"
  Write-Warning "タブ補完の削除に失敗しました: $_"
  Write-Warning "手動で $PROFILE にある '$dotSourceLine' を削除する必要があります。"
}
