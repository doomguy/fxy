## smbpasswd [cid]^: smbpasswd -r RHOST -U :cid_user
if [ "$1" == "smbpasswd" ]; then
  CMD="$1"; checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -eq 2 ]; then
    CID="$2"
    getCreds
  fi

  CMD="$CMD -r $RHOST -U $USRNME"
  echo "Password: $PASSWD"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
