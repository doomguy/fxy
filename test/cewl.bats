#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

@test "fxy cewl" {
  result="$(build/fxy cewl <<< N)"
  [ "$result" == "> cewl http://${RHOST}/ -w ${RHOST}_cewl.txt" ]
}

@test "fxy cewl s" {
  result="$(build/fxy cewl s <<< N)"
  [ "$result" == "> cewl https://${RHOST}/ -w ${RHOST}_cewl.txt" ]
}

@test "fxy cewl ssl" {
  result="$(build/fxy cewl ssl <<< N)"
  [ "$result" == "> cewl https://${RHOST}/ -w ${RHOST}_cewl.txt" ]
}

@test "fxy cewl tls" {
  result="$(build/fxy cewl tls <<< N)"
  [ "$result" == "> cewl https://${RHOST}/ -w ${RHOST}_cewl.txt" ]
}

@test "fxy cewl :8080/index.html" {
  result="$(build/fxy cewl :8080/index.html <<< N)"
  [ "$result" == "> cewl http://${RHOST}:8080/index.html -w ${RHOST}_cewl.txt" ]
}

@test "fxy cewl s :8080/index.html" {
  result="$(build/fxy cewl s :8080/index.html <<< N)"
  [ "$result" == "> cewl https://${RHOST}:8080/index.html -w ${RHOST}_cewl.txt" ]
}
