## r(host) [target]^: Show/Set RHOST
# Set RHOST
if [ "$#" -eq 2 ] && [[ "$1" =~ ^r(host)?$ ]]; then
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
