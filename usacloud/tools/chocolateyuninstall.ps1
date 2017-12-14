$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'usacloud*'
  zipFileName   = 'usacloud_windows-386.zip'
  zipFileName64 = 'usacloud_windows-amd64.zip'
}

# Only necessary if you did not unpack to package directory - see https://chocolatey.org/docs/helpers-uninstall-chocolatey-zip-package
$os = Get-WmiObject -Class Win32_OperatingSystem;
if ($os.OSarchitecture.Contains("64")) {
  Uninstall-ChocolateyZipPackage -PackageName $packageArgs['packageName'] -ZipFileName $packageArgs['zipFileName']
} else {
  Uninstall-ChocolateyZipPackage -PackageName $packageArgs['packageName'] -ZipFileName $packageArgs['zipFileName64']
}
