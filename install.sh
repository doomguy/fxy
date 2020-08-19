#!/usr/bin/env bash
FXYPATH="/usr/local/bin/fxy"
curl -s 'https://raw.githubusercontent.com/doomguy/fxy/master/build/fxy' -o "$FXYPATH"
chmod +x "$FXYPATH"
echo "[*] fxy has been installed to '$FXYPATH'"
echo "[*] run 'fxy fix deps | bash' as root to install all missing dependencies!"
