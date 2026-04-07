$ErrorActionPreference = 'Stop';

$packageName = $env:ChocolateyPackageName;

Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'usacloud_windows-386.zip'
Uninstall-ChocolateyZipPackage -PackageName $packageName -ZipFileName 'usacloud_windows-amd64.zip'
