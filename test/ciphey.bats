#!/usr/bin/env bats

@test            "fxy ciphey MTIzNDU2" {
  result="$(build/fxy ciphey MTIzNDU2 <<< Y)"
  [[ "$result" =~ Final\ result:\ \"123456\" ]]
}

@test            "fxy cyphey MTIzNDU2" {
  result="$(build/fxy cyphey MTIzNDU2 <<< Y)"
  [[ "$result" =~ Final\ result:\ \"123456\" ]]
}

@test            "fxy ciph MTIzNDU2" {
  result="$(build/fxy ciph MTIzNDU2 <<< Y)"
  [[ "$result" =~ Final\ result:\ \"123456\" ]]
}

@test            "fxy cyph MTIzNDU2" {
  result="$(build/fxy cyph MTIzNDU2 <<< Y)"
  [[ "$result" =~ Final\ result:\ \"123456\" ]]
}
