
# fxy
fxy is a small and smart bash script for fast command generation of common hacking and CTF related tasks. The source is completely modularized and adding new commands is super easy.

```
 .    .
 |\__/|
 /     \    |  FXY || Fox in the $hell   |
/_,- -,_\   |    github.com/doomguy/fxy  |
   \@/

Available commands:
  fxy b(ase)64(e|d) [input]                              : Base64 Encode/Decode
  fxy cewl [s(sl)|tls] [subdir]                          : cewl PROTO://RHOST+SUBDIR -w RHOST_cewl.txt
  fxy ciph(ey) [input]                                   : ciphey -t INPUT
  fxy cme|crackmapexec [smb]                             : crackmapexec smb RHOST | tee
  fxy c(reds) [a(dd) user:pass]|[d(el) cid]|[e(dit)]     : Show/Add/Del/Edit creds
  fxy curl [s(sl)|tls] [subdir]                          : curl -si PROTO://RHOST+SUBDIR | less
  fxy (cyber)chef [magic]                                : Open CyberChef in your browser
  fxy dirb [s(sl)|tls] [subdir]                          : dirb PROTO://RHOST+SUBDIR | tee
  fxy (evil-)winrm [cid]                                 : evil-winrm -i RHOST -u :cid_user -p :cid_pass
  fxy fix [deps|pip(3)|py(thon)(3)|sys(tem)]             : Fix stufff
  fxy h(ash)c(rack) [type] [hash|cid]                    : Crack hash
  fxy h(ash)i(d) [hash|cid]                              : Identify hash type
  fxy h(ash)s(earch) [help|any|md5|sha1|...] [hash|cid]  : Search for hashes
  fxy help                                               : Show this help
  fxy httpd|ws [port]                                    : python3 -m http.server PORT
  fxy hydra [help|service] [port] [username]             : hydra brute force (ssh, ftp, smb)
  fxy (i)conv|convert [file]                             : iconv -f UTF-16LE -t UTF-8 FILE -o FILE.conv
  fxy ip(s)                                              : Show interface and external IP(s)
  fxy ipwsh [port]                                       : Download InsecurePowerShell and serve via davserver
  fxy len(gth) [input]                                   : Show length of input
  fxy l(isten) [port]                                    : ncat -vlkp PORT
  fxy md5|sha(1)|sha2(56)|sha3(84)|sha5(12) [input]      : Generate hashes from input
  fxy nfs|showmount                                      : showmount -e RHOST
  fxy nikto [s(sl)|tls] [subdir]                         : nikto -host PROTO://RHOST+SUBDIR | tee
  fxy n(map) [full]                                      : nmap -v -A (-p-) RHOST | tee
  fxy pass(word)                                         : Show default machine password
  fxy peas [version] [port]                              : Download *peas and serve via http.server
  fxy p(ing) [count]                                     : ping -c COUNT RHOST
  fxy rev(shell) [help|type] [port]                      : Reverse shell generator (bash, php, python, perl, ...)
  fxy r(host) [target]                                   : Show/Set RHOST
  fxy rpc(client) [cid] [domain] [cmd]                   : rpcclient
  fxy smbpasswd [cid]                                    : smbpasswd -r RHOST -U :cid_user
  fxy socat [port]                                       : socat based listener
  fxy ssh [cid] [port]                                   : sshpass -e ssh :cid_user@RHOST -p PORT
  fxy up(date)                                           : Update fxy
  fxy u(ser)a(gent) [text]                               : Show/Set User-Agent
  fxy weevely [help|gen]                                 : weevely php shell
  fxy wfuzz [help|vhost]                                 : wfuzz | tee

```

## Easy to Install
```
curl https://raw.githubusercontent.com/doomguy/fxy/master/install.sh | bash
```

## fxy is Fun
```
$ fxy rhost webscantest.com

$ fxy r
  RHOST: webscantest.com

$ fxy nmap
> nmap -v -A webscantest.com -oA webscantest.com_nmap_2020-08-20_221653
[?] Run command? (y/N):

$ fxy nikto
> nikto -host http://webscantest.com/ | tee webscantest.com_nikto_2020-08-20_221718.log
[?] Run command? (y/N):

$ fxy md5 pass123
32250170a0dca92d53ec9624f336ca24

$ fxy b64 fxy.rocks
Znh5LnJvY2tz

$ fxy ciphey Znh5IHJvY2tz
> ciphey -t 'Znh5IHJvY2tz'
[?] Run command? (y/N): y
Format used:
  base64
  utf8
Final result: "fxy rocks"

$ fxy hs sha256 a32b722e08c256c1e701c2fc63f88064e9d76e9b01ade5f87fd2f2a6fe42b1a6
[*] (hashtoolkit.com) Match found: 's3cure'
```
