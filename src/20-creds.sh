## creds [add user:pass]|[del cid]^: Show/Add/Del creds
if [ "$1" == "creds" ]; then
  FILE="creds.txt"
  if [ "$#" -eq 1 ]; then
    showCreds; exit
  elif [ "$2" == "add" ] && [ "$#" -eq 3 ]; then
    # add entry
    ENTRY="$3"
    if [[ ! "$ENTRY" =~ .*:$ ]]; then
      ENTRY="$ENTRY:"
    fi
    CMD="echo '$ENTRY' >> $FILE"
  elif [ "$2" == "del" ] && [ "$#" -eq 3 ]; then
    # del entry
    CID="$3"
    if [ ! -e "$FILE" ]; then
      echo "${warn} No '$FILE' found!"; exit
    fi
    if [ "$CID" -gt "$(wc -l $FILE | cut -d' ' -f1)" ] || [ "$CID" -eq 0 ]; then
      echo "${warn} Invalid credential ID!"; exit
    fi
    CMD="sed -i '${CID}d' $FILE"
  elif [ "$2" == "edit" ]; then
    nano "$FILE"
    exit
  fi
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
