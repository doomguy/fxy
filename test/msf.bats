#!/usr/bin/env bats

# @test            "fxy msf" {
#   result="$(build/fxy msf <<< N)"
#   [[ "$result" =~ msfconsole\ \-x\ use\ exploit/multi/handler\;.*set\ PAYLOAD generic/shell_reverse_tcp\;.*set\ LHOST.*\;.*set\ LPORT\ 9001\;.*run ]]
# }

# @test            "fxy msf 12345" {
#   result="$(build/fxy msf 12345 <<< N)"
#   [[ "$result" =~ msfconsole\ \-x\ use\ exploit/multi/handler\;.*set\ PAYLOAD generic/shell_reverse_tcp\;.*set\ LHOST.*\;.*set\ LPORT\ 12345\;.*run ]]
# }

@test            "fxy msf payload 123invalid" {
  result="$(build/fxy msf payload 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}
