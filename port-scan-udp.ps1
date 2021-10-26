Function port-scan-udp {
  param($hosts,$ports,$out)
  if (!$ports) {
    Write-Host "usage: port-scan-udp <host|hosts> <port|ports> <cache|log file>"
    Write-Host " e.g.: port-scan-udp 192.168.1.2 445`n"
    return
  }
  if (!$out) {$out = ".\scanresults."+(Get-Date -Format "yyMMdd")+".txt"}
  foreach($p in [array]$ports) {
   foreach($h in [array]$hosts) {
    $x = (gc $out -EA SilentlyContinue | select-string "^$h,udp,$p,Open")
    if ($x) {
	  Writ-Host "`tCached:" 
      gc $out | select-string "^$h,udp,$p,Open"
	  Writ-Host "`tSearching:"
      continue
   }
    $msg = "$h,udp,$p,"
    $u = new-object system.net.sockets.udpclient
    $u.Client.ReceiveTimeout = 500
    $u.Connect($h,$p)
    # Send a single byte 0x01
    [void]$u.Send(1,1)
    $l = new-object system.net.ipendpoint([system.net.ipaddress]::Any,0)
    $r = "Filtered"
    try {
      if ($u.Receive([ref]$l)) {
        # We have received some UDP data from the remote host in return
        $r = "Open"
      }
    } catch {
      if ($Error[0].ToString() -match "failed to respond") {
        # We haven't received any UDP data from the remote host in return
        # Let's see if we can ICMP ping the remote host
        if ((Get-wmiobject win32_pingstatus -Filter "address = '$h' and Timeout=1000 and ResolveAddressNames=false").StatusCode -eq 0) {
          # We can ping the remote host, so we can assume that ICMP is not
          # filtered. And because we didn't receive ICMP port-unreachable before,
          # we can assume that the remote UDP port is open
          $r = "Open"
        }
      } elseif ($Error[0].ToString() -match "forcibly closed") {
        # We have received ICMP port-unreachable, the UDP port is closed
        $r = "Closed"
      }
    }
    $u.Close()
    Write-Host "`r$msg" -NoNewline
    $msg += $r
    if ($r -ne "Filtered"){ Write-Host "$r"}
    echo $msg >>$out
   }
  }
	Write-Host "`r                                                                        " -NoNewline
}

# Examples:

# write-host "Test ports:" ; 50..55 | sort-object {get-random} | % {port-scan-udp 31.192.111.206 $_}
#
# port-scan-udp 10.10.0.1 137
# port-scan-udp 10.10.0.1 (135,137,445)
# port-scan-udp (gc .\ips.txt) 137
# port-scan-udp (gc .\ips.txt) (135,137,445)
# 0..255 | foreach { port-scan-udp 10.10.0.$_ 137 }
# 0..255 | foreach { port-scan-udp 10.10.0.$_ (135,137,445) }
