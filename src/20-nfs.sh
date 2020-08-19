## nfs|showmount^: showmount -e RHOST
if [ "$1" == "nfs" ] || [ "$1" == "showmount" ]; then
  CMD="showmount"; checkCmd
  CMD="showmount -e $RHOST"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
