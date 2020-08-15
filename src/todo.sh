# Show 2DOs - internal command
if [ "$#" -eq 1 ] && [ "$1" == "2do" ]; then
  grep -Ein "^##|^# 2DO|^# -" "$0" | sed 's,\\t.*,,'
  exit
fi
