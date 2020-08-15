#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test "fxy n" {
  result="$(build/fxy n <<< N)"
  [[ "$result" =~ \>\ nmap\ -v\ -A\ ${RHOST}\ -oA.* ]]
}

@test "fxy nmap" {
  result="$(build/fxy nmap <<< N)"
  [[ "$result" =~ \>\ nmap\ -v\ -A\ ${RHOST}\ -oA.* ]]
}

@test "fxy n full" {
  result="$(build/fxy n full <<< N)"
  [[ "$result" =~ \>\ nmap\ -p-\ -v\ -A\ ${RHOST}\ -oA.* ]]
}
