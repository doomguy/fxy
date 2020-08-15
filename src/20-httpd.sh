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
