#!/usr/bin/expect

## Usage: expect this.sh [hostname] [port] [username] [password]

set timeout 30
spawn ssh -p [lindex $argv 1] [lindex $argv 2]@[lindex $argv 0]
expect {
  "(yes/no)?"
  {send "yes\n";exp_continue}
  "password:"
  {send "[lindex $argv 3]\n";exp_continue}
  ":~]"
  {send "su\n";exp_continue}
  "Password:"
  {send "[lindex $argv 3]\n"}
  "密码："
  {send "[lindex $argv 3]\ncd /faronear\n"}
}
interact
