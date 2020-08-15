## rpc(client) [cid] [domain] [cmd]^: rpcclient
#rpcclient -A auth.txt -W domain.local 10.10.10.193 -c "enumdomusers" > out.txt
if [ "$1" == "rpc" ] || [ "$1" == "rpcclient" ]; then
  CMD="rpcclient"; checkCmd

  # No ID supplied
  if [ "$#" -eq 1 ]; then
    showCreds
    exit
  fi

  # CredID supplied
  if [ "$#" -ge 2 ]; then
    # NULL session?
    if [ "$2" -eq 0 ]; then
      CMD="$CMD -U '' -N"
    else
      CID="$2"
      getCreds
      CMD="$CMD -U '$USRNME%$PASSWD'"
    fi
  fi

  # workgroup?
  WRKGRP=""
  if [ "$#" -ge 3 ]; then
    WRKGRP="-W $3"
  fi

  # command?
  CMND=""
  if [ "$#" -ge 4 ]; then
    CMND="-c $4 | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$4_$(date +%F_%H%M%S).log"
  fi

  CMD="$CMD $WRKGRP $RHOST $CMND"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
