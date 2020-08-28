#!/usr/bin/env bats

@test            "fxy ipwsh" {
  result="$(build/fxy ipwsh <<< N)"
  [[ "$result" =~ "Download InsecurePowerShell" ]]
}

@test            "fxy ipwsh 123invalid" {
  result="$(build/fxy ipwsh 123invalid <<< N)"
  [[ "$result" =~ "Port is not a number!" ]]
}
