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
Install-ChocolateyZipPackage @packageArgs;

# Create Usacloud Profile
$profileDir           = "$(Split-Path -Parent $PROFILE)";
$usacloudProfilePath  = "$(Join-Path $profileDir 'Usacloud.PowerShell_profile.ps1')";
if (-not (Test-Path $usacloudProfilePath)) {
  New-Item -Path $usacloudProfilePath -ItemType File -Force;
}

# Overwrite Profile
usacloud completion powershell | Out-File $usacloudProfileCheck;

# Create Profile
if (-not (Test-Path $PROFILE)) {
  New-Item -Path $PROFILE -ItemType File -Force;
}

# Append Load Script
if (-not (Select-String -Path $PROFILE -Pattern "usacloud" -Quiet)) {
  echo "# Usacloud profile"                                                                                          | Out-File -Append $PROFILE;
  echo "`$UsacloudProfile = `"`$(Join-Path `$(Split-Path -Parent `$PROFILE) `'Usacloud.PowerShell_profile.ps1`')`";" | Out-File -Append $PROFILE;
  echo "if (Test-Path(`$UsacloudProfile)) {"                                                                         | Out-File -Append $PROFILE;
  echo "  . `$UsacloudProfile;"                                                                                      | Out-File -Append $PROFILE;
  echo "}"                                                                                                           | Out-File -Append $PROFILE;
}

# Reload profile
. $PROFILE;
