## fix [deps|pip(3)|py(3)′python(3)]^: Fix stufff
if [[ "$1" =~ ^fix$ ]] && [ "$#" -eq 2 ]; then
  if [[ "$2" =~ ^dep(s|endencies)$ ]]; then
    echo '# Run this to fix all fxy dependencies:'
    echo '#   fxy fix deps | bash'
    grep "export INSTCMD" "$0" | grep -v 'grep " export' | cut -d'=' -f2 | sort | while read -r LINE; do
      # Remove double quotes
      LINE=$(sed 's,^"\(.*\)"$,\1,' <<< "$LINE")
      echo "$LINE"
    done
  elif [[ "$2" =~ ^pip(3)?$ ]]; then
    CMD="/usr/bin/python3 -m pip install --upgrade pip"
    echo "> $CMD"; prompt; bash -c "$CMD"
  elif [[ "$2" =~ ^py(3)?|python(3)?$ ]]; then
    CMD="pip list --outdated --format=freeze | cut -d'=' -f1 | xargs -n1 pip install --upgrade"
    echo "> $CMD"; prompt; bash -c "$CMD"
  fi
  exit
fi
