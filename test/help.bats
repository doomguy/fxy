#!/usr/bin/env bats

@test            "fxy" {
  result="$(build/fxy)"
  [[ "$result" =~ github.com/doomguy/fxy ]]
}

@test            "fxy h" {
  result="$(build/fxy h)"
  [[ "$result" =~ github.com/doomguy/fxy ]]
}

@test            "fxy help" {
  result="$(build/fxy help)"
  [[ "$result" =~ github.com/doomguy/fxy ]]
}
