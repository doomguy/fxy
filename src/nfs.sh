## nfs|showmount^: showmount -e RHOST
if [ "$1" == "nfs" ] || [ "$1" == "showmount" ]; then
  CMD="showmount"; checkCmd
  CMD="showmount -e $RHOST"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
