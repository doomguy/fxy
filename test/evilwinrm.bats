#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy evil-winrm" {
  result="$(build/fxy evil-winrm)"
  [[ "$result" =~ "Available creds" ]]
}

@test            "fxy winrm" {
  result="$(build/fxy winrm)"
  [[ "$result" =~ "Available creds" ]]
}

@test            "fxy winrm 0" {
  result="$(build/fxy winrm 0 <<< N)"
  [[ "$result" =~ "> evil-winrm -i $RHOST -u 'NULL' -p 'NULL'" ]]
}
