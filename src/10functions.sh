prompt() {
  read -p "[?] Run command? (y/N): " -n 1 -r
  echo
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    exit
  fi
}

showHead() {
echo ' .    .
 |\__/|
 /     \    |  FOXACID  ||   shell wizard    |
/_,- -,_\   | https://github.com/doomguy/fxy |
   \@/
'
}

showHelp() {
  showHead
  #echo -e "\n[ FOXACID || shell wizard ][ https://github.com/doomguy/fxy ]\n"
  echo "Available commands:"
  grep "^##" "$0" | sort | column -t -s'^' | sed 's,##,  fxy ,'
  echo
}

INSTCMD=""
checkCmd() {
  if [ ! "$(which "$CMD")" ]; then
    echo "[!] '$CMD' required but missing."
    if [ -n "$INSTCMD" ]; then
      echo "> $INSTCMD"; prompt; bash -c "$INSTCMD";
    else
      exit
    fi
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
