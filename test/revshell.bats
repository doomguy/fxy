#!/usr/bin/env bats

@test            "fxy rev" {
  result="$(build/fxy rev)"
  [[ "$result" =~ "Available commands for 'revshell'" ]]
}

@test            "fxy revshell" {
  result="$(build/fxy revshell)"
  [[ "$result" =~ "Available commands for 'revshell'" ]]
}

@test            "fxy rev help" {
  result="$(build/fxy rev help)"
  [[ "$result" =~ "Available commands for 'revshell'" ]]
}

@test            "fxy revshell help" {
  result="$(build/fxy revshell help)"
  [[ "$result" =~ "Available commands for 'revshell'" ]]
}
