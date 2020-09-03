#!/usr/bin/env bats

@test                              "fxy ws" { skip
  result="$(timeout -s INT 2s build/fxy ws)"
  [[ "$result" =~ python3\ -m\ http.server\ 80 ]]
}

@test                             "fxy httpd" { skip
  result="$(timeout 2s -s 15 build/fxy httpd)"
  [ grep -q '> python3 -m http.server 80' <<< "$result" ]
}

@test            "fxy ws 123invalid" {
  result="$(build/fxy ws 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}

@test            "fxy wss 123invalid" {
  result="$(build/fxy wss 123invalid)"
  [[ "$result" =~ "Port is not a number!" ]]
}
