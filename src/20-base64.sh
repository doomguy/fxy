## b(ase)64(e|d) [input]^: Base64 Encode/Decode
if [[ "$1" =~ ^b(ase)?64(e|d)?$ ]] && [ "$#" -eq 2 ]; then
  CMD="base64"; checkCmd
  case "$1" in
    "b64"|"b64e"|"base64"|"base64e")  echo -n "$2" | base64; echo; exit ;;
    "b64d"|"base64d")                 echo -n "$2" | base64 -d; echo; exit ;;
    *)                                echo "[!] Error parsing type of operation!"; exit ;;
  esac
fi
