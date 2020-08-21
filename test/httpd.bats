#!/usr/bin/env bats

@test                              "fxy ws" { skip
  result="$(timeout -s INT 2s build/fxy ws)"
  [[ "$result" =~ python3\ -m\ http.server\ 80 ]]
}

@test                             "fxy httpd" { skip
  result="$(timeout 2s -s 15 build/fxy httpd)"
  [ grep -q '> python3 -m http.server 80' <<< "$result" ]
}
