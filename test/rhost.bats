#!/usr/bin/env bats

@test "fxy r" {
  result="$(build/fxy r)"
  [[ "$result" =~ .*RHOST:\ .* ]]
}

@test "fxy rhost" {
  result="$(build/fxy r)"
  [[ "$result" =~ .*RHOST:\ .* ]]
}

@test "fxy r example.com" {
  # save rhost
  RHOST="$(fxy rhost | cut -d' ' -f 4)"
  build/fxy r example.com
  result="$(build/fxy r)"
  # restore previous rhost
  build/fxy r "$RHOST"
  [[ "$result" =~ .*RHOST:\ example.com ]]
}
