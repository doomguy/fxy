## u(ser)a(gent) [text]^: Show/Set User-Agent
# Set USRAGENT
DEFAULTUA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36'
if [[ "$1" =~ ^u(ser)?a(gent)?$ ]] && [ "$#" -ge 2 ]; then
  FPATH="/dev/shm/.fxy"
  FILE="/dev/shm/.fxy/useragent"
  if [ "$#" -ge 2 ]; then
    if [ ! -d "$FPATH" ]; then
      mkdir "$FPATH"
    fi

    # if more than 2 args, use args >=2 as input
    INPUT="$2"
    if [ "$#" -ge 3 ]; then
      INPUT="$(echo "$@" | cut -d' ' -f2-)"
    fi

    if [[ "$2" =~ ^default|reset$ ]]; then
      INPUT="$DEFAULTUA"
    fi

    echo "$INPUT" > $FILE
  fi
  exit
fi

# Load USRAGENT from cache
FILE="/dev/shm/.fxy/useragent"
if [ -f $FILE ]; then
  USRAGENT="$(cat $FILE)"
  export USRAGENT

  if [ -z "$USRAGENT" ]; then
     echo "[!] Something went wrong on loading '$FILE'"
     USRAGENT="$DEFAULTUA"
     export USRAGENT
  fi
else
  USRAGENT="$DEFAULTUA"
  export USRAGENT
fi

# Show USRAGENT
if [[ "$1" =~ ^u(ser)?a(gent)?$ ]] && [ "$#" -eq 1 ]; then
  echo "  User-Agent: $USRAGENT"
  exit
fi
