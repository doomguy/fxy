#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy nikto" {
  result="$(build/fxy nikto <<< N)"
  [[ "$result" =~ nikto\ -host\ http://${RHOST}/\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}

@test            "fxy nikto s" {
  result="$(build/fxy nikto s <<< N)"
  [[ "$result" =~ nikto\ -host\ https://${RHOST}/\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}

@test            "fxy nikto ssl" {
  result="$(build/fxy nikto ssl <<< N)"
  [[ "$result" =~ nikto\ -host\ https://${RHOST}/\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}

@test            "fxy nikto tls" {
  result="$(build/fxy nikto tls <<< N)"
  [[ "$result" =~ nikto\ -host\ https://${RHOST}/\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}

@test            "fxy nikto :8080/index.html" {
  result="$(build/fxy nikto :8080/index.html <<< N)"
  [[ "$result" =~ nikto\ -host\ http://${RHOST}:8080/index.html\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}

@test            "fxy nikto s :8080/index.html" {
  result="$(build/fxy nikto s :8080/index.html <<< N)"
  [[ "$result" =~ nikto\ -host\ https://${RHOST}:8080/index.html\ \|\ tee\ ${RHOST}_nikto_.*\.log ]]
}
