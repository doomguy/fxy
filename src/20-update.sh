## update^: Update fxy
if [ "$1" == "update" ]; then
  if [ "$(which git)" ]; then
    FXYPATH=$(sed 's,fxy$,,' <<< "$0")
    cd "$FXYPATH" || exit
    if [ "$(git config remote.origin.url)" == "git@github.com:doomguy/fxy.git" ]; then
      echo git pull
      exit
    fi
  else
    CMD="wget"
    INSTCMD="sudo apt install wget"
    checkCmd

    echo wget 'https://raw.githubusercontent.com/doomguy/fxy/master/build/fxy' -O "$0"
    chmod +x "$0"
    exit
  fi
fi
