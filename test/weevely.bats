#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"
PASSWD="$(fxy pass | grep : | cut -d' ' -f 6)"

@test            "fxy weevely gen" {
  result="$(build/fxy weevely gen <<< N)"
  [[ "$result" =~ "> weevely generate $PASSWD fxy.php" ]]
}

@test             "fxy weevely gen test.php" {
  result="$(build/fxy weevely gen test.php <<< N)"
  [[ "$result" =~ "> weevely generate $PASSWD test.php" ]]
}

@test            "fxy weevely gen test.php 123456" {
  result="$(build/fxy weevely gen test.php 123456 <<< N)"
  [[ "$result" =~ "> weevely generate 123456 test.php" ]]
}

@test            "fxy weevely" {
  result="$(build/fxy weevely <<< N)"
  [[ "$result" =~ "> weevely http://$RHOST/fxy.php $PASSWD" ]]
}

@test            "fxy weevely s" {
  result="$(build/fxy weevely s <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST/fxy.php $PASSWD" ]]
}

@test            "fxy weevely ssl" {
  result="$(build/fxy weevely ssl <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST/fxy.php $PASSWD" ]]
}

@test            "fxy weevely tls" {
  result="$(build/fxy weevely tls <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST/fxy.php $PASSWD" ]]
}

@test            "fxy weevely :8080/files/" {
  result="$(build/fxy weevely :8080/files/ <<< N)"
  [[ "$result" =~ "> weevely http://$RHOST:8080/files/fxy.php $PASSWD" ]]
}

@test            "fxy weevely s :8080/files/" {
  result="$(build/fxy weevely s :8080/files/ <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST:8080/files/fxy.php $PASSWD" ]]
}

@test            "fxy weevely :8080/files/ test.php" {
  result="$(build/fxy weevely :8080/files/ test.php <<< N)"
  [[ "$result" =~ "> weevely http://$RHOST:8080/files/test.php $PASSWD" ]]
}

@test            "fxy weevely s :8080/files/ test.php" {
  result="$(build/fxy weevely s :8080/files/ test.php <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST:8080/files/test.php $PASSWD" ]]
}

@test            "fxy weevely :8080/files/ test.php 123456" {
  result="$(build/fxy weevely :8080/files/ test.php 123456 <<< N)"
  [[ "$result" =~ "> weevely http://$RHOST:8080/files/test.php 123456" ]]
}

@test            "fxy weevely s :8080/files/ test.php 123456" {
  result="$(build/fxy weevely s :8080/files/ test.php 123456 <<< N)"
  [[ "$result" =~ "> weevely https://$RHOST:8080/files/test.php 123456" ]]
}
