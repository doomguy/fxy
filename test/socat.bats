#!/usr/bin/env bats

@test            "fxy socat 123invalid" {
  result="$(build/fxy socat 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}
