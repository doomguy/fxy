## pass(word)^: Show default machine password
if [ "$#" -eq 1 ] && [[ "$1" =~ ^pass(word)?$ ]]; then
  getMachinePass
  echo -e "\n  The following password is used as default value in various locations and is unique to this machine."
  echo -e "\n  Default machine password: $PASSWD\n"
  exit
fi
