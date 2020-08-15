#!/usr/bin/env bats

@test "fxy ua" {
  result="$(build/fxy ua)"
  [[ "$result" =~ User-Agent: ]]
}

@test "fxy useragent" {
  result="$(build/fxy useragent)"
  [[ "$result" =~ User-Agent: ]]
}

@test "fxy ua TestAgent" {
  # save rhost
  UA="$(fxy ua | cut -d' ' -f 4-)"
  build/fxy ua TestAgent
  result="$(build/fxy ua)"
  # restore previous rhost
  build/fxy ua "$UA"
  [[ "$result" =~ User-Agent:\ TestAgent ]]
}

@test "fxy ua Test Agent" {
  # save rhost
  UA="$(fxy ua | cut -d' ' -f 4-)"
  build/fxy ua Test Agent
  result="$(build/fxy ua)"
  # restore previous rhost
  build/fxy ua "$UA"
  [[ "$result" =~ User-Agent:\ Test\ Agent ]]
}

@test "fxy ua default" {
  # save rhost
  UA="$(fxy ua | cut -d' ' -f 4-)"
  build/fxy ua TestAgent
  build/fxy ua default
  result="$(build/fxy ua)"
  # restore previous rhost
  build/fxy ua "$UA"
  [[ "$result" =~ User-Agent:\ Mozilla/5.0 ]]
}

@test "fxy ua reset" {
  # save rhost
  UA="$(fxy ua | cut -d' ' -f 4-)"
  build/fxy ua TestAgent
  build/fxy ua reset
  result="$(build/fxy ua)"
  # restore previous rhost
  build/fxy ua "$UA"
  [[ "$result" =~ User-Agent:\ Mozilla/5.0 ]]
}
