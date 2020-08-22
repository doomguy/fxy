## httpd|ws [port]^: python3 -m http.server PORT
if [ "$1" == "httpd" ] || [ "$1" == "ws" ] ; then
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
  echo "URL: http://$(getIP)/"
  echo "DIR: $(pwd)"
  for f in $(find . -maxdepth 1 -type f 2>/dev/null | sed 's,\./,,' | sed 's, ,+,'); do
    echo "- http://$(getIP)/$f";
  done
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
