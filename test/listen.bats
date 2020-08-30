#!/usr/bin/env bats

@test            "fxy listen 123invalid" {
  result="$(build/fxy listen 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}

@test            "fxy l 123invalid" {
  result="$(build/fxy l 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}
