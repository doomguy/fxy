#!/usr/bin/env bats

@test            "fxy c" {
  result="$(build/fxy c)"
  [[ "$result" =~ "Available creds" ]]
}

@test            "fxy creds" {
  result="$(build/fxy creds)"
  [[ "$result" =~ "Available creds" ]]
}

@test            "fxy c a alice:123456" {
  result="$(build/fxy c a alice:123456 <<< N)"
  [[ "$result" =~ "> echo 'alice:123456:' >> creds.txt" ]]
}

@test            "fxy creds a alice:123456" {
  result="$(build/fxy creds a alice:123456 <<< N)"
  [[ "$result" =~ "> echo 'alice:123456:' >> creds.txt" ]]
}

@test            "fxy creds add alice:123456" {
  result="$(build/fxy creds add alice:123456 <<< N)"
  [[ "$result" =~ "> echo 'alice:123456:' >> creds.txt" ]]
}

@test            "fxy c add alice:123456" {
  result="$(build/fxy c add alice:123456 <<< N)"
  [[ "$result" =~ "> echo 'alice:123456:' >> creds.txt" ]]
}

@test            "fxy c d" {
  result="$(build/fxy c d)"
  [[ "$result" =~ "Available creds" ]]
}

@test            "fxy c d 1 (no file)" {
  result="$(build/fxy c d 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy c del 1 (no file)" {
  result="$(build/fxy c del 1)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy c d 1 (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy c d 1 <<< N)"
  rm creds.txt
  [[ "$result" =~ "> sed -i '1d' creds.txt" ]]
}

# fxy creds edit
