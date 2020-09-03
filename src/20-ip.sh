## ip(s)^: Show local and external IP(s)
if [[ "$1" =~ ^ip(s)?$ ]]; then
  CMD="ip"; checkCmd
  ip a \
    | sed -E 's/^[ ]{1,}//gm' \
    | grep -E '^(.:|inet)' \
    | cut -d' ' -f1-2 \
    | sed 's,^inet,  inet,g'
  echo "X: extip"
  echo -n "  inet "; getExtIP; echo
  exit
fi
