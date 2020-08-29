# Show 2DOs - internal command
if [ "$#" -eq 1 ] && [[ "$1" =~ ^(2|to)do$ ]]; then
  grep -Ein "^##|^# 2DO|^# -" "$0" | sed 's,\\t.*,,'
  exit
fi

# 2DO:
# - gobuster dir -u http://10.10.10.191/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php
# - msf multi handler
# - msf venom most common
# - smbclient
# - smbmap
# - enum4linux
# - bash one liners
# - fxy help cid > validation
