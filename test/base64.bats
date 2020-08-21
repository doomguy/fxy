#!/usr/bin/env bats

# encode input

@test            "fxy b64 123456" {
  result="$(build/fxy b64 123456)"
  [ "$result" == "MTIzNDU2" ]
}

@test            "fxy b64e 123456" {
  result="$(build/fxy b64e 123456)"
  [ "$result" == "MTIzNDU2" ]
}

@test            "fxy base64 123456" {
  result="$(build/fxy base64 123456)"
  [ "$result" == "MTIzNDU2" ]
}

@test            "fxy base64e 123456" {
  result="$(build/fxy base64e 123456)"
  [ "$result" == "MTIzNDU2" ]
}

@test            "fxy b64 123 456" {
  result="$(build/fxy b64 123 456)"
  [ "$result" == "MTIzIDQ1Ng==" ]
}

# decode input

@test            "fxy b64d MTIzNDU2" {
  result="$(build/fxy b64d MTIzNDU2)"
  [ "$result" == "123456" ]
}

@test            "fxy base64d MTIzNDU2" {
  result="$(build/fxy base64d MTIzNDU2)"
  [ "$result" == "123456" ]
}
