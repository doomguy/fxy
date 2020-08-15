## h(ash)i(d) [hash]^: Identify hash type
if { [ "$1" == "hashid" ] || [ "$1" == "hid" ] || [ "$1" == "hi" ]; } && [ "$#" -eq 2 ]; then
  HASH="$2"
  if [ "$(which hashid)" ]; then
    echo "=== hashid ==="
    hashid "$HASH" | grep -v ^Analyzing; echo
  fi
  if [ "$(which hash-identifier)" ] ;then
    echo "=== hash-identifier ==="
    echo -n "$HASH" | hash-identifier 2>/dev/null| sed '1,14d' | head -n -2
  fi
  exit
fi
