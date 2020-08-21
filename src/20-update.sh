## up(date)^: Update fxy
if [[ "$1" =~ ^up(date)?$ ]]; then
  # update for git clone
  if [ "$(which git)" ]; then
    FXYPATH=$(sed 's,fxy$,,' <<< "$0")
    cd "$FXYPATH" || exit
    if [[ "$(git config remote.origin.url)" =~ doomguy/fxy\.git$ ]]; then
      git fetch --all \
        && git reset --hard origin/master \
        && echo "${info} Update successful!"
      exit
    fi
  fi

  # update for non-git installations
  CMD="wget"
  export INSTCMD="apt install wget -y"
  checkCmd

  wget 'https://raw.githubusercontent.com/doomguy/fxy/master/build/fxy' -O "$0" \
  && chmod +x "$0" \
  && echo "${info} Update successful!"
  exit
fi
