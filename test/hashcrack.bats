#!/usr/bin/env bats

@test            "fxy hashcrack md5 1" {
  result="$(build/fxy hashcrack md5 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hc md5 1" {
  result="$(build/fxy hc md5 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hc md5 0" {
  result="$(build/fxy hc md5 0 <<< N)"
  [[ "$result" =~ "john --format=raw-md5 --wordlist /usr/share/wordlists/rockyou.txt --fork=2 --pot=hash.pot hash_unknown.txt" ]]
}

@test            "fxy hc sha1 0" {
  result="$(build/fxy hc sha1 0 <<< N)"
  [[ "$result" =~ "john --format=raw-sha1 --wordlist /usr/share/wordlists/rockyou.txt --fork=2 --pot=hash.pot hash_unknown.txt" ]]
}

@test            "fxy hc sha256 0" {
  result="$(build/fxy hc sha256 0 <<< N)"
  [[ "$result" =~ "john --format=raw-sha256 --wordlist /usr/share/wordlists/rockyou.txt --fork=2 --pot=hash.pot hash_unknown.txt" ]]
}

@test            "fxy hc sha512 0" {
  result="$(build/fxy hc sha512 0 <<< N)"
  [[ "$result" =~ "john --format=raw-sha512 --wordlist /usr/share/wordlists/rockyou.txt --fork=2 --pot=hash.pot hash_unknown.txt" ]]
}
