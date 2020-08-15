## fix [deps]^: Fix stufff
if [[ "$1" =~ ^fix$ ]] && [ "$#" -eq 2 ]; then
  if [[ "$2" =~ dep(s|endencies) ]]; then
    echo '# Run this to fix all dependencies:'
    echo '#   fxy fix deps | bash'
    grep "export INSTCMD" "$0" | grep -v 'grep " export' | cut -d'=' -f2 | sort | while read -r LINE; do
      # Remove double quotes
      LINE=$(sed 's,^"\(.*\)"$,\1,' <<< "$LINE")
      echo "$LINE"
    done
  fi
  exit
fi
