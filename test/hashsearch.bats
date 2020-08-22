#!/usr/bin/env bats

@test            "fxy hs lm invalid" {
  result="$(build/fxy hs lm invalid)"
  [[ "$result" =~ Invalid\ LM\ Hash ]]
}

@test            "fxy hs nt invalid" {
  result="$(build/fxy hs nt invalid)"
  [[ "$result" =~ Invalid\ NT\ Hash ]]
}

@test            "fxy hs md5 invalid" {
  result="$(build/fxy hs md5 invalid)"
  [[ "$result" =~ Invalid\ MD5\ Hash ]]
}

@test            "fxy hs sha1 invalid" {
  result="$(build/fxy hs sha1 invalid)"
  [[ "$result" =~ Invalid\ SHA1\ Hash ]]
}

@test            "fxy hs sha256 invalid" {
  result="$(build/fxy hs sha256 invalid)"
  [[ "$result" =~ Invalid\ SHA256\ Hash ]]
}

@test            "fxy hs sha384 invalid" {
  result="$(build/fxy hs sha384 invalid)"
  [[ "$result" =~ Invalid\ SHA384\ Hash ]]
}

@test            "fxy hs sha512 invalid" {
  result="$(build/fxy hs sha512 invalid)"
  [[ "$result" =~ Invalid\ SHA512\ Hash ]]
}

@test            "fxy hs md5 d41d8cd98f00b204e9800998ecf8427e" {
  result="$(build/fxy hs md5 d41d8cd98f00b204e9800998ecf8427e)"
  [[ "$result" =~ Empty\ MD5\ Hash ]]
}

@test            "fxy hs sha1 da39a3ee5e6b4b0d3255bfef95601890afd80709" {
  result="$(build/fxy hs sha1 da39a3ee5e6b4b0d3255bfef95601890afd80709)"
  [[ "$result" =~ Empty\ SHA1\ Hash ]]
}

@test            "fxy hs sha256 e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" {
  result="$(build/fxy hs sha256 e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855)"
  [[ "$result" =~ Empty\ SHA256\ Hash ]]
}

@test            "fxy hs sha384 38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b" {
  result="$(build/fxy hs sha384 38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b)"
  [[ "$result" =~ Empty\ SHA384\ Hash ]]
}

@test            "fxy hs sha512 cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" {
  result="$(build/fxy hs sha512 cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e)"
  [[ "$result" =~ Empty\ SHA512\ Hash ]]
}

@test            "fxy hs lm aad3b435b51404ee" {
  result="$(build/fxy hs lm aad3b435b51404ee)"
  [[ "$result" =~ Empty\ LM\ Hash ]]
}

# worked 2020-08-18
@test            "fxy hs lm 44efce164ab921caaad3b435b51404ee (online)" { skip
  result="$(build/fxy hs lm 44efce164ab921caaad3b435b51404ee)"
  [[ "$result" =~ 123456 ]]
}

@test            "fxy hs md5 1" {
  result="$(build/fxy hs md5 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}
