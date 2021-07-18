#!/usr/bin/expect

## Usage: expect this.sh [user@hostname] [password] [filepath]
## Example: expect this.sh adot@server.log.yuanjin.net /faronear/tac.log/log.server.torm

set timeout 30
spawn ssh [lindex $argv 0]
expect {
  "(yes/no)?"
  {send "yes\n";exp_continue}
  "password:"
  {send "[lindex $argv 1]\n"}
  ":~"
  {send "su\n";exp_continue}
  "Password:"
  {send "[lindex $argv 1]\ncd [lindex $argv 2] && git pull && npx pm2 restart all && npx pm2 log\n"}
}
interact
