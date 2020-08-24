#!/usr/bin/env bats

@test            "fxy todo" {
  result="$(build/fxy todo)"
  [[ "$result" =~ '2DO:' ]]
}

@test            "fxy 2do" {
  result="$(build/fxy 2do)"
  [[ "$result" =~ "2DO:" ]]
}
