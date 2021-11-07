#!/usr/bin/expect

# Usage: expect this.sh [0:hostname] [1:username] [2:filepath] [3:pwdadot]

set timeout 10
spawn ssh [lindex $argv 1]@[lindex $argv 0] -p 22
expect {
  "yes/no"
  {send "yes\n";exp_continue}
  "password:"
  {send "[lindex $argv 3]\n";exp_continue}
  ":~"
  {send "cd [lindex $argv 2] && sudo git pull && sudo npx pm2 restart all && sudo npx pm2 log\n"}
}
interact
