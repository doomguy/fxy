## (evil-)winrm [cid]^: evil-winrm -i RHOST -u :cid_user -p :cid_pass
if [ "$1" == "evil-winrm" ] || [ "$1" == "winrm" ]; then
  CMD="evil-winrm"; checkCmd

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

  CMD="$CMD -i $RHOST -u '$USRNME' -p '$PASSWD'"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
