set -x
## update^: Update fxy
if [ "$1" == "update" ]; then

  # update for git clone
  if [ "$(which git)" ]; then
    FXYPATH=$(sed 's,fxy$,,' <<< "$0")
    cd "$FXYPATH" || exit
    if [[ "$(git config remote.origin.url)" =~ doomguy/fxy\.git$ ]]; then
      git fetch --all && git reset --hard origin/master
      exit
    fi
  fi

  # update for non-git installations
  CMD="wget"
  export INSTCMD="apt install wget"
  checkCmd

  wget 'https://raw.githubusercontent.com/doomguy/fxy/master/build/fxy' -O "$0"
  chmod +x "$0"
  exit
fi
