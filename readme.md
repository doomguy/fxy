
# fxy
Shell wizardry for hacking and CTF.

```
 .    .
 |\__/|
 /     \    | FOXACID || Fox in the $hell |
/_,- -,_\   |   github.com/doomguy/fxy    |
   \@/

Available commands:
  fxy  b(ase)64(e|d) [input]                          : Base64 Encode/Decode
  fxy  cewl [s|ssl|tls] [subdir]                      : cewl PROTO://RHOST+SUBDIR -w RHOST_cewl.txt
  fxy  ciph(ey) [input]                               : ciphey -t INPUT
  fxy  cme|crackmapexec [smb]                         : crackmapexec smb RHOST | tee
  fxy  creds [add user:pass]|[del cid]                : Show/Add/Del creds
  fxy  curl [s|ssl|tls] [subdir]                      : curl -si PROTO://RHOST+SUBDIR | less
  fxy  (cyber)chef [magic]                            : Open CyberChef in your browser
  fxy  dirb [s|ssl|tls] [subdir]                      : dirb PROTO://RHOST+SUBDIR | tee
  fxy  (evil-)winrm [cid]                             : evil-winrm -i RHOST -u :cid_user -p :cid_pass
  fxy  fix [deps|pip(3)|py(thon)(3)|sys(tem)]         : Fix stufff
  fxy  h(ash)c(rack) [type] [hash|cid]                : Crack hash
  fxy  h(ash)i(d) [hash]                              : Identify hash type
  fxy  h(ash)s(earch) [md5|sha1|...] [hash]           : Search for hashes
  fxy  h(elp)                                         : Show this help
  fxy  httpd|ws [port]                                : python3 -m http.server PORT
  fxy  hydra [service] [port] [username]              : hydra brute force (ssh, ftp, smb)
  fxy  (i)conv|convert [file]                         : iconv -f UTF-16LE -t UTF-8 FILE -o FILE.conv
  fxy  ip(s)                                          : Show interface and external IP(s)
  fxy  ipwsh [port]                                   : Download InsecurePowerShell and serve via davserver
  fxy  len(gth) [input]                               : Show length of input
  fxy  l(isten) [port]                                : ncat -vlkp PORT
  fxy  md5|sha(1)|sha2(56)|sha3(84)|sha5(12) [input]  : Generate hashes from input
  fxy  nfs|showmount                                  : showmount -e RHOST
  fxy  nikto [s|ssl|tls] [subdir]                     : nikto -host PROTO://RHOST+SUBDIR | tee
  fxy  n(map) [full]                                  : nmap -v -A (-p-) RHOST | tee
  fxy  pass(word)                                     : Show default machine password
  fxy  peas [version] [port]                          : Download *peas and serve via http.server
  fxy  p(ing) [count]                                 : ping -c COUNT RHOST
  fxy  rev(shell) [type] [port]                       : Reverse shell generator (bash, php, python, perl, ...)
  fxy  r(host) [target]                               : Show/Set RHOST
  fxy  rpc(client) [cid] [domain] [cmd]               : rpcclient
  fxy  smbpasswd [cid]                                : smbpasswd -r RHOST -U :cid_user
  fxy  socat [port]                                   : socat based listener
  fxy  ssh [cid] [port]                               : sshpass -e ssh :cid_user@RHOST -p PORT
  fxy  update                                         : Update fxy
  fxy  u(ser)a(gent) [text]                           : Show/Set User-Agent
  fxy  weevely [gen|help]                             : weevely php shell
  fxy  wfuzz                                          : wfuzz | tee

```
