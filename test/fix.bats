#!/usr/bin/env bats

@test "fxy fix deps" {
  result="$(build/fxy fix deps <<< N)"
  [[ "$result" =~ fxy\ fix\ deps\ \|\ bash ]]
}

@test "fxy fix dependencies" {
  result="$(build/fxy fix dependencies <<< N)"
  [[ "$result" =~ fxy\ fix\ deps\ \|\ bash ]]
}

@test "fxy fix pip" {
  result="$(build/fxy fix pip <<< N)"
  [[ "$result" =~ /usr/bin/python3\ -m\ pip\ install\ --upgrade\ pip ]]
}

@test "fxy fix pip3" {
  result="$(build/fxy fix pip3 <<< N)"
  [[ "$result" =~ /usr/bin/python3\ -m\ pip\ install\ --upgrade\ pip ]]
}

@test "fxy fix python" {
  result="$(build/fxy fix python <<< N)"
  [[ "$result" =~ pip\ install\ --upgrade ]]
}

@test "fxy fix python3" {
  result="$(build/fxy fix python <<< N)"
  [[ "$result" =~ pip\ install\ --upgrade ]]
}

@test "fxy fix py" {
  result="$(build/fxy fix py <<< N)"
  [[ "$result" =~ pip\ install\ --upgrade ]]
}

@test "fxy fix py3" {
  result="$(build/fxy fix py3 <<< N)"
  [[ "$result" =~ pip\ install\ --upgrade ]]
}
