## (i)conv|convert [file]^: iconv -f UTF-16LE -t UTF-8 FILE -o FILE.conv
if { [ "$1" == "iconv" ] || [ "$1" == "conv" ] || [ "$1" == "convert" ]; } && [ "$#" -eq 2 ]; then
  CMD="iconv"; checkCmd

  FILE="$2"
  if [ ! -f "$FILE" ]; then
    echo "[!] Invalid input file!"; exit
  fi

  CMD="iconv -f UTF-16LE -t UTF-8 $FILE -o $FILE.conv"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
