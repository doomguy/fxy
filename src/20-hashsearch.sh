## h(ash)s(earch) [md5|sha1|...] [hash]^: Search for hashes
# hashsearch help
if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -eq 1 ]; then
  echo "Available commands:"
  echo "  fxy h(ash)s(earch) [md5|sha(1)|sha2(56)|sha3(56)|sha5(12)] [hash]"
  exit
fi

if { [ "$1" == "hashsearch" ] || [ "$1" == "hs" ]; } && [ "$#" -ge 3 ]; then
  HASH="$3"

  case "$2" in
    "md5")              TYPE="md5";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{32}$ ]] || { echo "${warn} Invalid MD5 Hash!"; exit; };
                        [ "$HASH" == 'd41d8cd98f00b204e9800998ecf8427e' ] && { echo "${warn} Empty MD5 Hash!"; exit; } ;;
    "sha"|"sha1")       TYPE="sha1";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{40}$ ]] || { echo "${warn} Invalid SHA1 Hash!"; exit; };
                        [ "$HASH" == 'da39a3ee5e6b4b0d3255bfef95601890afd80709' ] && { echo "${warn} Empty SHA1 Hash!"; exit; } ;;

    "sha256"|"sha2")    TYPE="sha256";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{64}$ ]] || { echo "${warn} Invalid SHA256 Hash!"; exit; };
                        [ "$HASH" == 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' ] && { echo "${warn} Empty SHA256 Hash!"; exit; } ;;

    "sha384"|"sha3")    TYPE="sha384";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{96}$ ]] || { echo "${warn} Invalid SHA384 Hash!"; exit; };
                        [ "$HASH" == '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b' ] && { echo "${warn} Empty SHA384 Hash!"; exit; } ;;

    "sha512"|"sha5")    TYPE="sha512";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{128}$ ]] || { echo "${warn} Invalid SHA512 Hash!"; exit; };
                        [ "$HASH" == 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e' ] && { echo "${warn} Empty SHA512 Hash!"; exit; } ;;

    "lm"|"LM")          TYPE="lm";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{16,32}$ ]] || { echo "${warn} 111 Invalid LM Hash!"; exit; };
                        [ "$HASH" == 'aad3b435b51404ee' ] && { echo "${warn} Empty LM Hash!"; exit; } ;;

    "nt"|"NT")          TYPE="nt";
                        [[ "$HASH" =~ ^[A-Za-z0-9]{32}$ ]] || { echo "${warn} Invalid NT Hash!"; exit; } ;;

    *)                  echo "${warn} Error parsing type of hash!"; exit ;;
  esac

  [ "${4-default}" == "q" ] || sleep 2

  # hashtoolkit.com
  if [[ "$TYPE" =~ ^md5|sha1|sha256|sha384|sha512$ ]]; then
    RES="$(curl -ski -A "$USRAGENT" https://hashtoolkit.com/reverse-"$TYPE"-hash/?hash="$HASH")"

    if [ -n "$(grep -i 'No hashes found for' <<< "$RES")" ]; then
      echo "${warn} (hashtoolkit.com) No match found!";
    else
      PASSWD="$(grep -m 1 -io "/generate-hash/?text=.*>" <<< "$RES" | cut -d'>' -f2 | sed 's,</a,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "${info} (hashtoolkit.com) Match found: '$PASSWD'"; exit
    fi
  fi

  # gromweb.com
  if [[ "$TYPE" =~ ^md5|sha1$ ]]; then
    case "$TYPE" in
      "md5")        RES="$(curl -ski -A "$USRAGENT" https://md5.gromweb.com/?md5="$HASH")" ;;
      "sha1")       RES="$(curl -ski -A "$USRAGENT" https://sha1.gromweb.com/?hash="$HASH")" ;;
      *)            echo "${warn} Error parsing type of hash!"; exit ;;
    esac

    PASSWD="$(grep -i "was succesfully reversed" -A1 <<< "$RES" | grep "long-content string" | cut -d'>' -f2 | sed 's,</em.*,,' )"
    if [ -z "$RES" ]; then
      echo "${warn} (gromweb.com) No match found!";
    else
      echo "${info} (gromweb.com) Match found: '$PASSWD'"; exit
    fi
  fi

  # objectif-securite.ch
  if [ "$TYPE" == "nt" ]; then
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
      -H 'Connection: close' \
      --data-binary '{"value":"'"$HASH"'"}' \
      --compressed)

    PASSWD="$(jq -r .msg <<< "$RES")"
    if [[  ! "$RES" =~ Password\ not\ found ]]; then
      echo "${warn} (objectif-securite.ch) No match found!";
    else
      echo "${info} (objectif-securite.ch) Match found: '$PASSWD'"; exit
    fi
  fi

  # it64.com
  if [ "$TYPE" == "lm" ]; then
    HLEN="$(echo -n "$HASH" | wc -c)"
    if { [[ ! "$HASH" =~ ^[A-Za-z0-9]{16}$ ]] && [[ ! "$HASH" =~ ^[A-Za-z0-9]{32}$ ]]; } || [ "$HASH" == "aad3b435b51404ee" ]; then
      echo "${warn} Invalid LM Hash!"; exit
    fi

    HASHES="$(echo -n "$HASH" | cut -c1-16)"
    if [ "$HLEN" -eq 32 ]; then
      HASH2="$(echo -n "$HASH" | cut -c17-32)"
      if [ "$HASH2" != "aad3b435b51404ee" ]; then
        HASHES="$HASHES $HASH2"
      fi
    fi

    PASSWD=""
    IFS=' '; for h in $HASHES; do
      RES=$(curl -sk 'http://rainbowtables.it64.com/p3.php' \
        -H "user-agent: $USRAGENT" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        --compressed \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: http://rainbowtables.it64.com' \
        -H 'DNT: 1' \
        -H 'Connection: close' \
        -H 'Referer: http://rainbowtables.it64.com/p3.php' \
        -H 'Upgrade-Insecure-Requests: 1' \
        --data-raw 'hashe='"$h"'&ifik=+Submit+&forma=tak')

      if [[ "$RES" =~ CRACKED ]]; then
        PASSWD="${PASSWD}$(grep -o  'CRACKED&nbsp;</TD><TD>&nbsp;.*&nbsp;' <<< "$RES" | sed 's/.*&nbsp;\(.*\)&nbsp;/\1/')"
      fi

    done

    if [ -n "$PASSWD" ]; then
      echo "${info} (it64.com) Match found: '${PASSWD}'"; exit
    else
      echo "${warn} (it64.com) No match found!"
    fi
  fi

  # online-domain-tools.com
  if [[ "$TYPE" =~ ^md5|sha1|sha256|lm|nt$ ]]; then
    if [ "$TYPE" == "nt" ]; then TYPE="ntlm"; fi
    RES=$(curl -ski -A "$USRAGENT" "https://reverse-hash-lookup.online-domain-tools.com/" --data "text=$HASH&function=$TYPE&do=form-submit&phone=5deab72563840e7678c4067671849b85332d7438&send=%3E+Reverse!")
    if [ -n "$(grep -i 'You do not have enough credits in your account.' <<< "$RES")" ]; then
      echo "${warn} (online-domain-tools.com) No free credits left!";
    elif [ -n "$(grep -i 'Hash #1:</b> ERROR:' <<< "$RES")" ]; then
      echo "${warn} (online-domain-tools.com) No match found or error!";
    else
      PASSWD="$(grep -o -m 1 "Hash #1.*" <<< "$RES" | cut -d' ' -f3 | sed 's,</.*$,,')"
      PASSWD="$(sed 's,&lt;,<,' <<< "$PASSWD")"
      PASSWD="$(sed 's,&gt;,>,' <<< "$PASSWD")"
      echo "${info} (online-domain-tools.com) Match found: '$PASSWD'"
    fi
  fi

  # Still here?
  echo -e "\nNothing found so far. Want to do it manually on crackstation.net?"
  CMD="firefox 'https://crackstation.net'"
  echo "${bldwht}> $CMD${txtrst}"; prompt; bash -c "$CMD"; exit
fi
# 2DO:
# - https://md5decrypt.net/en/Api/ - signup broken
# - access online-domain-tools.com via tor for more free creds?
# - implement more lm/ntlm crackers
