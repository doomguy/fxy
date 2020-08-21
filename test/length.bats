#!/usr/bin/env bats

@test "fxy len" {
  result="$(build/fxy len)"
  [[ "$result" =~ doomguy/fxy ]]
}

@test "fxy length" {
  result="$(build/fxy length)"
  [[ "$result" =~ doomguy/fxy ]]
}

@test "fxy len 123456" {
  result="$(build/fxy len 123456 | tail -n1)"
  [[ "$result" -eq 6 ]]
}

@test "fxy length 123456" {
  result="$(build/fxy length 123456 | tail -n1)"
  [[ "$result" -eq 6 ]]
}

@test "fxy length '123456'" {
  result="$(build/fxy length '123456' | tail -n1)"
  [[ "$result" -eq 6 ]]
}


@test "fxy len 12345 6" {
  result="$(build/fxy len 12345 6 | tail -n1)"
  [[ "$result" -eq 7 ]]
}

@test "fxy len '12345 6'" {
  result="$(build/fxy len '12345 6' | tail -n1)"
  [[ "$result" -eq 7 ]]
}
