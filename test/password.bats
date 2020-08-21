#!/usr/bin/env bats

@test            "fxy pass" {
  result="$(build/fxy pass)"
  [[ "$result" =~ Default\ machine\ password ]]
}

@test            "fxy password" {
  result="$(build/fxy password)"
  [[ "$result" =~ Default\ machine\ password ]]
}
