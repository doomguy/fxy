## ssh [cid] [port]^: sshpass -e ssh :cid_user@RHOST -p PORT
if [ "$1" == "ssh" ]; then
  CMD="sshpass";
  export INSTCMD="apt install sshpass -y"
  checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -ge 2 ]; then
    CID="$2"
    getCreds
  fi

  export SSHPASS=$PASSWD
  CMD="sshpass -v -e ssh -o StrictHostKeyChecking=no $USRNME@$RHOST"

  # port?
  if [ "$#" -eq 3 ]; then
    PORT="$3"
    CMD="$CMD -p $PORT"
  fi

  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
