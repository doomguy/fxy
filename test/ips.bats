#!/usr/bin/env bats

@test            "fxy ips" {
  result="$(build/fxy ips)"
  [[ "$result" =~ inet ]]
}

@test            "fxy ip" {
  result="$(build/fxy ip)"
  [[ "$result" =~ inet ]]
}
