## ciph(ey) [input]^: ciphey -t INPUT
if [[ "$1" =~ ^c(i|y)ph((e)?y)?$ ]] && [ "$#" -ge 2 ]; then
  CMD="ciphey"
  export INSTCMD="python3 -m pip install ciphey --upgrade"
  checkCmd

  # if more than 2 args, use args >=2 as input
  INPUT="$2"
  if [ "$#" -ge 3 ]; then
    INPUT="$(echo "$@" | cut -d' ' -f2-)"
  fi

  CMD="$CMD -t '$INPUT'"
  echo "${bldwht}> $CMD${txtrst}"; prompt; bash -c "$CMD";
  exit
fi
