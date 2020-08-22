#!/usr/bin/env bats

@test            "fxy iconv bats.log" {
  result="$(build/fxy iconv bats.log <<< N)"
  [[ "$result" =~ "iconv -f UTF-16LE -t UTF-8 bats.log -o bats.log.conv" ]]
}

@test            "fxy conv bats.log" {
  result="$(build/fxy conv bats.log <<< N)"
  [[ "$result" =~ "iconv -f UTF-16LE -t UTF-8 bats.log -o bats.log.conv" ]]
}

@test            "fxy convert bats.log" {
  result="$(build/fxy conv bats.log <<< N)"
  [[ "$result" =~ "iconv -f UTF-16LE -t UTF-8 bats.log -o bats.log.conv" ]]
}
