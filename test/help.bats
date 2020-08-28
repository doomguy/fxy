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

@test            "fxy h ssh" {
  result="$(build/fxy h ssh)"
  [[ "$result" =~ "Found entries for 'ssh'" ]]
}

@test            "fxy h sshr" {
  result="$(build/fxy h sshr)"
  [[ "$result" =~ "Nothing found" ]]
}
