Function smblogin-worker {
  param($h,$u,$p)
  $u = $u -replace "^\.\\", "$h\"
  $c = New-Object System.Management.Automation.PSCredential $u, ($p | ConvertTo-SecureString -AsPlainText -Force)
  try {
    if (New-PSDrive -Name Share -PSProvider FileSystem -Root \\$h\Admin$ -Credential $c -EA SilentlyContinue) {
      Remove-PSDrive Share
      echo "True,admin"
    } else {
      if ($error[0].exception -Match 'password is incorrect') {
        echo "False"
      } elseif ($error[0].exception -Match 'Access is denied') {
        echo "True"
      }
    }
  } catch {
    echo "Error"
  }
}

Function smblogin {
  param($hosts,$user,$pass)
  if (!$pass) { return }
  $results = ".\smblogin.results.txt"
  $userm = ($user -replace "\\", "\\") -replace "\.", "\."
  foreach($ip in gc $hosts) {
    $x = (gc $results -EA SilentlyContinue | sls "^$ip,$userm,.*,True")
    if ($x) {
      Write-Host "user $user on $ip already found"
      continue
    }
    $x = (gc $results -EA SilentlyContinue | sls -CaseSensitive "^$ip,$userm,$pass,")
    if ($x) {
      Write-Host "user $user on $ip with $pass already tried"
      continue
    }
    $output = "$ip,$user,$pass,"
    $output += smblogin-worker $ip $user $pass
    Write-Host "$output"
    echo $output | Out-File -Encoding ascii -Append $results
  }
}