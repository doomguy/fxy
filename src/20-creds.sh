## c(reds) [a(dd) user:pass]|[d(el) cid]|[e(dit)]^: Show/Add/Del/Edit creds
if [[ "$1" =~ ^c(reds)?$ ]]; then
  FILE="creds.txt"
  CMD=""
  if [ "$#" -eq 1 ]; then # show creds
    showCreds; exit
  elif [[ "$2" =~ ^a(dd)?$ ]] && [ "$#" -eq 3 ]; then # add entry
    ENTRY="$3"
    if [[ ! "$ENTRY" =~ .*:$ ]]; then
      ENTRY="$ENTRY:"
    fi
    CMD="echo '$ENTRY' >> $FILE"
  elif [[ "$2" =~ ^d(el)?$ ]] && [ "$#" -eq 3 ]; then # del entry
    CID="$3"
    if [ ! -e "$FILE" ]; then
      echo "${warn} No '$FILE' found!"; exit
    fi
    if [ "$CID" -gt "$(wc -l $FILE | cut -d' ' -f1)" ] || [ "$CID" -eq 0 ]; then
      echo "${warn} Invalid credential ID!"; exit
    fi
    CMD="sed -i '${CID}d' $FILE"
  elif [[ "$2" =~ ^e(dit)?$ ]]; then # edit creds
    nano "$FILE"
    exit
  fi
  if [ -z "$CMD" ]; then showCreds; exit; fi
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
