#!/usr/bin/env bats

RHOST="$(fxy rhost | cut -d' ' -f 4)"

# show help screen
@test            "fxy hydra" {
  result="$(build/fxy hydra)"
  [[ "$result" =~ "For more check out" ]]
}

# no creds.txt
@test            "fxy hydra ssh (no file)" {
  result="$(build/fxy hydra ssh)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hydra ftp (no file)" {
  result="$(build/fxy hydra ftp)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hydra smb (no file)" {
  result="$(build/fxy hydra smb)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

@test            "fxy hydra http (no file)" {
  result="$(build/fxy hydra http)"
  [[ "$result" =~ "No 'creds.txt' found!" ]]
}

# with creds.txt

@test            "fxy hydra ssh (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra ssh <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 22 $RHOST ssh" ]]
}

@test            "fxy hydra ssh 9001 (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra ssh 9001 <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 9001 $RHOST ssh" ]]
}

@test            "fxy hydra ssh 123invalid (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra ssh 123invalid <<< N)"
  rm creds.txt
  [[ "$result" =~ "Port is not a number!" ]]
}

@test            "fxy hydra ssh 9001 alice (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra ssh 9001 alice <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -l alice -P /dev/shm/.fxy/pass.lst -u -e sr -s 9001 $RHOST ssh" ]]
}

@test            "fxy hydra ftp (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra ftp <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 21 $RHOST ftp" ]]
}

@test            "fxy hydra smb (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra smb <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 445 $RHOST smb" ]]
}

@test            "fxy hydra http (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra http <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 80 $RHOST http-get /" ]]
}

@test            "fxy hydra http 443 (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra http 443 <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -L /dev/shm/.fxy/user.lst -P /dev/shm/.fxy/pass.lst -u -e sr -s 443 $RHOST http-get /" ]]
}

@test            "fxy hydra http 443 alice (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra http 443 alice <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -l alice -P /dev/shm/.fxy/pass.lst -u -e sr -s 443 $RHOST http-get /" ]]
}

@test            "fxy hydra http 443 alice /certsrv/ (with file)" {
  echo 'alice:123456:' > creds.txt
  result="$(build/fxy hydra http 443 alice /certsrv/ <<< N)"
  rm creds.txt
  [[ "$result" =~ "hydra -I -l alice -P /dev/shm/.fxy/pass.lst -u -e sr -s 443 $RHOST http-get /certsrv/" ]]
}
