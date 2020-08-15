#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test "fxy cme smb" {
  result="$(build/fxy cme smb <<< N)"
  [[ "$result" =~ \>\ crackmapexec\ smb\ ${RHOST}\ \|\ tee.*\ ${RHOST}_cme_.* ]]
}

@test "fxy crackmapexec smb" {
  result="$(build/fxy crackmapexec smb <<< N)"
  [[ "$result" =~ \>\ crackmapexec\ smb\ ${RHOST}\ \|\ tee.*\ ${RHOST}_cme_.* ]]
}
