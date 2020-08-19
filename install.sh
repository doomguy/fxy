#!/usr/bin/env bash
FXYPATH="/usr/local/bin/fxy"
curl 'https://raw.githubusercontent.com/doomguy/fxy/master/build/fxy' -o "$FXYPATH"
chmod +x "$FXYPATH"
echo "[*] fxy has been installed to '$FXYPATH'"
