#!/usr/bin/env bats

@test            "fxy hashid 1" {
  result="$(build/fxy hashid 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hid 1" {
  result="$(build/fxy hid 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hi 1" {
  result="$(build/fxy hi 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hi e10adc3949ba59abbe56e057f20f883e" {
  result="$(build/fxy hi e10adc3949ba59abbe56e057f20f883e | grep -E 'hash|MD5')"
  [[ "$result" =~ hashid.*MD5.*hash-identifier.*MD5 ]]
}
