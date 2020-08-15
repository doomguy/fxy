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
