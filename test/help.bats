#!/usr/bin/env bats

@test "fxy" {
  result="$(build/fxy)"
  [[ "$result" =~ https://github.com/doomguy/fxy ]]
}

@test "fxy h" {
  result="$(build/fxy h)"
  [[ "$result" =~ https://github.com/doomguy/fxy ]]
}

@test "fxy help" {
  result="$(build/fxy help)"
  [[ "$result" =~ https://github.com/doomguy/fxy ]]
}
