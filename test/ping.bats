#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy ping 1" {
  # save rhost
  RHOST="$(fxy rhost | cut -d' ' -f 4)"
  build/fxy r 127.0.0.1
  result="$(build/fxy ping 1)"
  # restore previous rhost
  build/fxy r "$RHOST"
  [[ "$result" =~ "1 packets transmitted" ]]
}

@test            "fxy ping 123invalid" {
  result="$(build/fxy ping 123invalid)"
  [[ "$result" =~ "Not a number!" ]]
}
