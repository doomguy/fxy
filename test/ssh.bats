#!/usr/bin/env bats

@test            "fxy ssh 0 123invalid" {
  result="$(build/fxy ssh 0 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}
