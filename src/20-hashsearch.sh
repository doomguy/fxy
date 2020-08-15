## h(ash)s(earch) [md5|sha1|...] [hash]^: Search for hashes
# hashsearch help
if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy h(ash)s(earch) [md5|sha(1)|sha2(56)|sha3(56)|sha5(12)] [hash]"
  exit
fi

if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -eq 3 ]; then
  HASH="$3"

  case "$2" in
    "md5")              TYPE="md5" ;;
    "sha"|"sha1")       TYPE="sha1" ;;
    "sha256"|"sha2")    TYPE="sha256" ;;
    "sha384"|"sha3")    TYPE="sha356" ;;
    "sha512"|"sha5")    TYPE="sha512" ;;
    "lm"|"LM")          TYPE="lm" ;;
    "nt"|"NT")          TYPE="nt" ;;
    *)                  echo "[!] Error parsing type of hash!"; exit ;;
  esac

  # hashtoolkit.com
  if [[ "$TYPE" =~ ^md5|sha1|sha256|sha356|sha512$ ]]; then
    RES="$(curl -ski -A "$USRAGENT" https://hashtoolkit.com/reverse-"$TYPE"-hash/?hash="$HASH")"

    if [ -n "$(grep -i 'No hashes found for' <<< "$RES")" ]; then
      echo "[!] (hashtoolkit.com) No match found!";
    else
      PASSWD="$(grep -m 1 -io "/generate-hash/?text=.*>" <<< "$RES" | cut -d'>' -f2 | sed 's,</a,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "[*] (hashtoolkit.com) Match found: $PASSWD"; exit
    fi
  fi

  # gromweb.com
  if [[ "$TYPE" =~ ^md5|sha1$ ]]; then
    case "$TYPE" in
      "md5")        RES="$(curl -ski -A "$USRAGENT" https://md5.gromweb.com/?md5="$HASH")" ;;
      "sha1")       RES="$(curl -ski -A "$USRAGENT" https://sha1.gromweb.com/?hash="$HASH")" ;;
      *)            echo "[!] Error parsing type of hash!"; exit ;;
    esac

    PASSWD="$(grep -i "was succesfully reversed" -A1 <<< "$RES" | grep "long-content string" | cut -d'>' -f2 | sed 's,</em.*,,' )"
    if [ -z "$RES" ]; then
      echo "[!] (gromweb.com) No match found!";
    else
      echo "[*] (gromweb.com) Match found: $PASSWD"; exit
    fi
  fi

  # objectif-securite.ch
  if [[ "$TYPE" == "nt" ]]; then
    RES=$(curl -sk 'https://cracker.okx.ch/crack' \
      -H 'authority: cracker.okx.ch' \
      -H 'pragma: no-cache' \
      -H 'cache-control: no-cache' \
      -H 'accept: application/json, text/javascript, */*; q=0.01' \
      -H 'dnt: 1' \
      -H "user-agent: $USRAGENT" \
      -H 'content-type: application/json' \
      -H 'origin: https://www.objectif-securite.ch' \
      -H 'sec-fetch-site: cross-site' \
      -H 'sec-fetch-mode: cors' \
      -H 'sec-fetch-dest: empty' \
      -H 'referer: https://www.objectif-securite.ch/' \
      -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
      --data-binary '{"value":"'"$HASH"'"}' \
      --compressed)

    PASSWD="$(jq -r .msg <<< "$RES")"
    if [[  ! "$RES" =~ Password\ not\ found ]]; then
      echo "[!] (objectif-securite.ch) No match found!";
    else
      echo "[*] (objectif-securite.ch) Match found: $PASSWD"; exit
    fi
  fi

  # online-domain-tools.com
  if [[ "$TYPE" =~ ^md5|sha1|sha256|lm|nt$ ]]; then
    if [ "$TYPE" == "nt" ]; then TYPE="ntlm"; fi
    RES=$(curl -ski -A "$USRAGENT" "https://reverse-hash-lookup.online-domain-tools.com/" --data "text=$HASH&function=$TYPE&do=form-submit&phone=5deab72563840e7678c4067671849b85332d7438&send=%3E+Reverse!")
    if [ -n "$(grep -i 'You do not have enough credits in your account.' <<< "$RES")" ]; then
      echo "[!] (online-domain-tools.com) No free credits left!";
    elif [ -n "$(grep -i 'Hash #1:</b> ERROR:' <<< "$RES")" ]; then
      echo "[!] (online-domain-tools.com) No match found or error!";
    else
      PASSWD="$(grep -o -m 1 "Hash #1.*" <<< "$RES" | cut -d' ' -f3 | sed 's,</.*$,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "[*] (online-domain-tools.com) Match found: $PASSWD"
    fi
  fi

  # Still here?
  echo -e "\nNothing found so far. Want to do it manually on crackstation.net?"
  CMD="firefox 'https://crackstation.net'"
  echo "> $CMD"; prompt; bash -c "$CMD"; exit
fi
# 2DO:
# - https://md5decrypt.net/en/Api/ - signup broken
# - access online-domain-tools.com via tor for more free creds?
# - implement more lm/ntlm crackers
# - http://rainbowtables.it64.com/
#curl 'http://rainbowtables.it64.com/p3.php' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://rainbowtables.it64.com' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: http://rainbowtables.it64.com/p3.php' -H 'Cookie: PHPSESSID=7gkkqip7bk9crma6hnd3c09pb4' -H 'Upgrade-Insecure-Requests: 1' --data-raw 'hashe=44efce164ab921caaad3b435b51404ee&ifik=+Submit+&forma=tak'
