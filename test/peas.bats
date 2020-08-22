#!/usr/bin/env bats

@test            "fxy peas" {
  result="$(build/fxy peas)"
  [[ "$result" =~ "fxy peas lin" ]]
}

@test            "fxy peas lin" {
  result="$(build/fxy peas lin <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 80" ]]
}

@test            "fxy peas winbat" {
  result="$(build/fxy peas winbat <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 80" ]]
}

@test            "fxy peas winany" {
  result="$(build/fxy peas winany <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 80" ]]
}

@test            "fxy peas win86" {
  result="$(build/fxy peas win86 <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 80" ]]
}

@test            "fxy peas win64" {
  result="$(build/fxy peas win64 <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 80" ]]
}

@test            "fxy peas lin 9001" {
  result="$(build/fxy peas lin 9001 <<< N)"
  [[ "$result" =~ "Download *peas and serve via http.server on port 9001" ]]
}

@test            "fxy peas lin 123invalid" {
  result="$(build/fxy peas lin 123invalid <<< N)"
  [[ "$result" =~ "Port is not a number!" ]]
}
