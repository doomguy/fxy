## cme|crackmapexec [smb]^: crackmapexec smb RHOST | tee
if [ "$1" == "cme" ] || [ "$1" == "crackmapexec" ]; then
  CMD="crackmapexec"; checkCmd
  if [ "$#" -eq 2 ] && [ "$2" == "smb" ]; then
    CMD="$CMD smb"
  else
    exit
  fi
  CMD="$CMD $RHOST | tee ${RHOST}_cme_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
