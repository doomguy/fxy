## (cyber)chef [magic]^: Open CyberChef in your browser
if [[ "$1" =~ ^(cyber)?chef$ ]]; then
  CMD="xdg-open"; checkCmd
  CMD="xdg-open https://gchq.github.io/CyberChef/"

  if [ "$#" -eq 3 ] && [ "$2" == "magic" ]; then
    INPUT=$(echo -n "$3" | base64 | sed 's,=,%3D,g')
    CMD="xdg-open https://gchq.github.io/CyberChef/#recipe=Magic(3,false,false,'')&input=${INPUT}"
  fi

  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
