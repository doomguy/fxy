## ciph(ey) [input]^: ciphey -t INPUT
if [[ "$1" =~ ^c(i|y)ph(ey)?$ ]] && [ "$#" -eq 2 ]; then
  CMD="ciphey"
  export INSTCMD="python3 -m pip install ciphey --upgrade"
  checkCmd

  INPUT="$2"
  CMD="$CMD -t '$INPUT'"
  echo "> $CMD"; prompt; bash -c "$CMD";
  exit
fi
