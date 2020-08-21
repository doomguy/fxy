#!/usr/bin/env bats

@test            "fxy md5 123456" {
  result="$(build/fxy md5 123456)"
  [ "$result" == "e10adc3949ba59abbe56e057f20f883e" ]
}

@test            "fxy sha 123456" {
  result="$(build/fxy sha 123456)"
  [ "$result" == "7c4a8d09ca3762af61e59520943dc26494f8941b" ]
}

@test            "fxy sha1 123456" {
  result="$(build/fxy sha1 123456)"
  [ "$result" == "7c4a8d09ca3762af61e59520943dc26494f8941b" ]
}

@test            "fxy sha2 123456" {
  result="$(build/fxy sha2 123456)"
  [ "$result" == "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92" ]
}

@test            "fxy sha256 123456" {
  result="$(build/fxy sha256 123456)"
  [ "$result" == "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92" ]
}

@test            "fxy sha3 123456" {
  result="$(build/fxy sha3 123456)"
  [ "$result" == "0a989ebc4a77b56a6e2bb7b19d995d185ce44090c13e2984b7ecc6d446d4b61ea9991b76a4c2f04b1b4d244841449454" ]
}

@test            "fxy sha384 123456" {
  result="$(build/fxy sha384 123456)"
  [ "$result" == "0a989ebc4a77b56a6e2bb7b19d995d185ce44090c13e2984b7ecc6d446d4b61ea9991b76a4c2f04b1b4d244841449454" ]
}

@test            "fxy sha5 123456" {
  result="$(build/fxy sha5 123456)"
  [ "$result" == "ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413" ]
}

@test            "fxy sha512 123456" {
  result="$(build/fxy sha512 123456)"
  [ "$result" == "ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413" ]
}

@test            "fxy md5 123 456" {
  result="$(build/fxy md5 123 456)"
  [ "$result" == "39c278294f0267d0cb2b414be79f5f13" ]
}

@test            "fxy md5 '123 456'" {
  result="$(build/fxy md5 '123 456')"
  [ "$result" == "39c278294f0267d0cb2b414be79f5f13" ]
}
