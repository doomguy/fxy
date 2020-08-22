#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy ping 1" {
  result="$(build/fxy ping 1)"
  [[ "$result" =~ "ping -c 1 $RHOST" ]]
}

@test            "fxy ping 123invalid" {
  result="$(build/fxy ping 123invalid)"
  [[ "$result" =~ "Not a number!" ]]
}
