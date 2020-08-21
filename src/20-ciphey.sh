## ciph(ey) [input]^: ciphey -t INPUT
if [[ "$1" =~ ^c(i|y)ph((e)?y)?$ ]] && [ "$#" -eq 2 ]; then
  CMD="ciphey"
  export INSTCMD="python3 -m pip install ciphey --upgrade"
  checkCmd

  INPUT="$2"
  CMD="$CMD -t '$INPUT'"
  echo "${bldwht}> $CMD${txtrst}"; prompt; bash -c "$CMD";
  exit
fi
