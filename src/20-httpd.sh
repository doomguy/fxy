## httpd|ws [port]^: Spawn python3 http webserver
if [ "$1" == "httpd" ] || [ "$1" == "ws" ] ; then
  CMD="python3"
  checkCmd
  CMD="python3 -m http.server"
  PORT="80"
  if [ "$#" -eq 2 ]; then
    if [[ "$2" =~ ^[0-9]+$ ]]; then # is it a number?
      PORT="$2"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi
  CMD="$CMD $PORT"
  IP=$(getIP)
  echo "URL: http://$IP:$PORT/"
  echo "DIR: $(pwd)"
  for f in $(find . -maxdepth 1 -type f 2>/dev/null | sed 's,\./,,' | sed 's, ,+,' | sort); do
    echo "- http://$IP:$PORT/$f";
  done
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi

## httpsd|wss [port]^: Spawn openssl https webserver
if [ "$1" == "httpsd" ] || [ "$1" == "wss" ] ; then
  CMD="openssl"
  checkCmd
  FPATH="/dev/shm/.fxy"
  PORT="443"
  if [ "$#" -eq 2 ]; then
    if [[ "$2" =~ ^[0-9]+$ ]]; then # is it a number?
      PORT="$2"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi

  # generate key if not present
  if [ ! -e "$FPATH/fxy.key" ] || [ ! -e "$FPATH/fxy.crt" ]; then
    mkdir -p "$FPATH" || exit
    openssl req -x509 \
     -nodes -days 365 -newkey rsa:2048 -sha256 \
     -keyout "$FPATH/fxy.key" \
     -out "$FPATH/fxy.crt" \
     -subj "/C=FX/ST=FXY/L=FXY/CN=FXY.ROCKS"
  fi

  CMD="openssl s_server -key $FPATH/fxy.key -cert $FPATH/fxy.crt -accept $PORT -WWW"

  IP=$(getIP)
  echo "URL: https://$IP:$PORT/"
  echo "DIR: $(pwd)"
  for f in $(find . -maxdepth 1 -type f 2>/dev/null | sed 's,\./,,' | sed 's, ,+,' | sort); do
    echo "- https://$IP:$PORT/$f";
  done
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
