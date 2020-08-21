#!/usr/bin/env bats

@test            "fxy cyberchef" {
  result="$(build/fxy cyberchef <<< N)"
  [[ "$result" =~ "> firefox https://gchq.github.io/CyberChef/" ]]
}

@test            "fxy chef" {
  result="$(build/fxy chef <<< N)"
  [[ "$result" =~ "> firefox https://gchq.github.io/CyberChef/" ]]
}

@test            "fxy chef magic Znh5LnJvY2tz" {
  result="$(build/fxy chef magic Znh5LnJvY2tz)"
  [[ "$result" =~ "https://gchq.github.io/CyberChef/#recipe=Magic(3,false,false,'')&input=Wm5oNUxuSnZZMnR6" ]]
}
