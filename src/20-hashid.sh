## h(ash)i(d) [hash|cid]^: Identify hash type
if [[ "$1" =~ ^h(ash)?i(d)?$ ]] && [ "$#" -eq 2 ]; then
  HASH="$2"
  if [ "$(echo -n "$HASH" | wc -c)" -le 2 ] && [ "$HASH" -ge 1 ]; then
    # assume a cid is given since hash is too short
    CID="$2"
    getCreds
    if [ -z "$HASH" ]; then
      echo "${warn} No hash found for credential ID '$CID'"; exit
    fi
    echo -e "${info} Identifying hash: $HASH\n"
  fi

  if [ "$(which hashid)" ]; then
    echo "=== hashid ==="
    hashid "$HASH" | grep -v ^Analyzing; echo
  fi
  if [ "$(which hash-identifier)" ] ;then
    echo "=== hash-identifier ==="
    echo -n "$HASH" | hash-identifier 2>/dev/null | sed '1,14d' | head -n -2
  fi
  exit
fi
