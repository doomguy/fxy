#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy dirb" {
  result="$(build/fxy dirb <<< N)"
  [[ "$result" =~ dirb\ http://${RHOST}/\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}

@test            "fxy dirb s" {
  result="$(build/fxy dirb s <<< N)"
  [[ "$result" =~ dirb\ https://${RHOST}/\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}

@test            "fxy dirb ssl" {
  result="$(build/fxy dirb ssl <<< N)"
  [[ "$result" =~ dirb\ https://${RHOST}/\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}

@test            "fxy dirb tls" {
  result="$(build/fxy dirb tls <<< N)"
  [[ "$result" =~ dirb\ https://${RHOST}/\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}

@test            "fxy dirb :8080/index.html" {
  result="$(build/fxy dirb :8080/index.html <<< N)"
  [[ "$result" =~ dirb\ http://${RHOST}:8080/index.html\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}

@test            "fxy dirb s :8080/index.html" {
  result="$(build/fxy dirb s :8080/index.html <<< N)"
  [[ "$result" =~ dirb\ https://${RHOST}:8080/index.html\ -a\ .*\ \|\ tee\ ${RHOST}_dirb_.*\.log ]]
}
