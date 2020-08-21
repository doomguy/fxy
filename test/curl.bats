#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test            "fxy curl" {
  result="$(build/fxy curl <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ http://${RHOST}/ ]]
}

@test            "fxy curl s" {
  result="$(build/fxy curl s <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ https://${RHOST}/ ]]
}

@test            "fxy curl ssl" {
  result="$(build/fxy curl ssl <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ https://${RHOST}/ ]]
}

@test            "fxy curl tls" {
  result="$(build/fxy curl tls <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ https://${RHOST}/ ]]
}

@test            "fxy curl :8080/index.html" {
  result="$(build/fxy curl :8080/index.html <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ http://${RHOST}:8080/index.html ]]
}

@test            "fxy curl s :8080/index.html" {
  result="$(build/fxy curl s :8080/index.html <<< N)"
  [[ "$result" =~ curl\ -ski\ -A.*\ https://${RHOST}:8080/index.html ]]
}
