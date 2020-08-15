## md5|sha(1)|sha2(56)|sha3(84)|sha5(12) [input]^: Generate hashes from input
if { [[ "$1" =~ ^md5|sha(1)?|sha2(56)?|sha3(84)?|sha5(12)?$ ]]; } && [ "$#" -ge 2 ]; then
  TYPE="$1"
  INPUT="$2"

  # if more than 2 args, use args >=2 as input
  if [ "$#" -ge 3 ]; then
    INPUT=$(echo "$@" | cut -d' ' -f2-)
  fi

  case "$TYPE" in
    "md5" )             CMD="md5sum" ;;
    "sha"|"sha1")       CMD="sha1sum" ;;
    "sha256"|"sha2")    CMD="sha256sum" ;;
    "sha384"|"sha3")    CMD="sha384sum" ;;
    "sha512"|"sha5")    CMD="sha512sum" ;;
    *)                  echo "[!] Error parsing type of hash!"; exit ;;
  esac

  checkCmd
  echo -n "$INPUT" | $CMD | cut -d' ' -f1
  exit
fi
