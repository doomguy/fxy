#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"
# help
@test            "fxy wfuzz help" {
  result="$(build/fxy wfuzz help)"
  [[ "$result" =~ "Available commands for 'wfuzz'" ]]
}

# vhost
@test            "fxy wfuzz vhost" {
  result="$(build/fxy wfuzz vhost <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.$RHOST' -u 'http://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost s" {
  result="$(build/fxy wfuzz vhost s <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.$RHOST' -u 'https://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost ssl" {
  result="$(build/fxy wfuzz vhost ssl <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.$RHOST' -u 'https://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost tls" {
  result="$(build/fxy wfuzz vhost tls <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.$RHOST' -u 'https://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost example.com" {
  result="$(build/fxy wfuzz vhost example.com <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'http://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost s example.com" {
  result="$(build/fxy wfuzz vhost s example.com <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'https://$RHOST' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt" ]]
}

@test            "fxy wfuzz vhost example.com 123" {
  result="$(build/fxy wfuzz vhost example.com 123 <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'http://127.0.0.1' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt --hw 123" ]]
}

@test            "fxy wfuzz vhost s example.com 123" {
  result="$(build/fxy wfuzz vhost s example.com 123 <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'https://127.0.0.1' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt --hw 123" ]]
}

@test            "fxy wfuzz vhost example.com 123 456" {
  result="$(build/fxy wfuzz vhost example.com 123 456 <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'http://127.0.0.1' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt --hw 123 --hc 456" ]]
}

@test            "fxy wfuzz vhost s example.com 123 456" {
  result="$(build/fxy wfuzz vhost s example.com 123 456 <<< N)"
  [[ "$result" =~ "wfuzz -H 'Host: FUZZ.example.com' -u 'https://127.0.0.1' -w /dev/shm/.fxy/wfuzz/subdomains-top1million-20000.txt --hw 123 --hc 456" ]]
}

# normal
@test            "fxy wfuzz" {
  result="$(build/fxy wfuzz <<< N)"
  [[ "$result" =~ "wfuzz -u 'http://$RHOST/' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ]]
}

@test            "fxy wfuzz s" {
  result="$(build/fxy wfuzz s <<< N)"
  [[ "$result" =~ "wfuzz -u 'https://$RHOST/' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ]]
}

@test            "fxy wfuzz ssl" {
  result="$(build/fxy wfuzz ssl <<< N)"
  [[ "$result" =~ "wfuzz -u 'https://$RHOST/' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ]]
}

@test            "fxy wfuzz tls" {
  result="$(build/fxy wfuzz tls <<< N)"
  [[ "$result" =~ "wfuzz -u 'https://$RHOST/' -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ]]
}
