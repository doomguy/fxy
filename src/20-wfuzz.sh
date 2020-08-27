## wfuzz [help|vhost]^: wfuzz | tee
# wfuzz help
if [ "$1" == "wfuzz" ] && { [ "$#" -eq 2 ] && [ "$2" == "help" ]; }; then
  echo "Available commands for 'wfuzz':"
  echo "  fxy wfuzz vhost [s(sl)|tls] [domain] [hw] [hc]"
  echo "  fxy wfuzz [s(sl)|tls] [subdir] [hw] [hc]"
  exit
fi

# wfuzz vhost
if [ "$#" -ge 2 ] && [ "$1" == "wfuzz" ] && [ "$2" == "vhost" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  DOMAIN="$RHOST"
  if [ "$#" -ge 3 ]; then
    # https?
    if [[ "$3" =~ ^s(sl)?|tls$ ]]; then
      PROTO="https"
    fi

    if [ "$#" -ge 4 ] && [ "$PROTO" == "https" ]; then
      DOMAIN="$4"
    elif [ "$#" -ge 3 ] && [ "$PROTO" == "http" ]; then
      DOMAIN="$3"
    fi
  fi

  # Setup tmp path and wordlist
  FPATH="/dev/shm/.fxy/wfuzz"
  if [ ! -d "$FPATH" ]; then
    mkdir -p "$FPATH"
  fi
  cd "$FPATH"
  if [ ! -f "subdomains-top1million-20000.txt" ]; then
    wget 'https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-20000.txt' -O subdomains-top1million-20000.txt
  fi

  HW=""; HC=""
  if [ "$#" -eq 4 ] && [ "$PROTO" == "http" ];  then HW="--hw $4"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "http" ];  then HW="--hw $4"; HC="--hc $5"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then HW="--hw $5"; fi
  if [ "$#" -eq 6 ] && [ "$PROTO" == "https" ]; then HW="--hw $5"; HC="--hc $6"; fi

  CMD="wfuzz -H 'Host: FUZZ.$DOMAIN' -u '$PROTO://$RHOST' -w $FPATH/subdomains-top1million-20000.txt $HW $HC"
  CMD="$CMD | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_vhost_$(date +%F_%H%M%S).log"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  rm -rf "$FPATH"
  exit
fi

# wfuzz normal
if [ "$1" == "wfuzz" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUB="/"
  if [ "$#" -ge 2 ]; then
    # https?
    if [[ "$2" =~ ^s(sl)?|tls$ ]]; then
      PROTO="https"
    fi

    if [ "$#" -ge 3 ] && [ "$PROTO" == "https" ]; then
      SUB="$3"
    elif [ "$#" -ge 2 ] && [ "$PROTO" == "http" ]; then
      SUB="$2"
    fi
  fi

  HW=""; HC=""
  if [ "$#" -eq 3 ] && [ "$PROTO" == "http" ];  then HW="--hw $3"; fi
  if [ "$#" -eq 4 ] && [ "$PROTO" == "http" ];  then HW="--hw $3"; HC="--hc $4"; fi
  if [ "$#" -eq 4 ] && [ "$PROTO" == "https" ]; then HW="--hw $4"; fi
  if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then HW="--hw $4"; HC="--hc $5"; fi

  CMD="wfuzz -u '$PROTO://${RHOST}${SUB}' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt $HW $HC"
  CMD="$CMD | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  rm -rf "$FPATH"
  exit
fi
