#!/usr/bin/env bats

@test            "fxy todo" {
  result="$(build/fxy todo 2>&1)"
  [[ "$result" =~ '2DO:' ]]
}

@test            "fxy 2do" {
  result="$(build/fxy 2do)"
  [[ "$result" =~ "2DO:" ]]
}
