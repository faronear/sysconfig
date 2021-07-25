#!/usr/bin/expect

# Usage: expect this.sh [hostname] [username] [pwdadot] [pwdroot]

set timeout 30
spawn ssh [lindex $argv 1]@[lindex $argv 0] -p 22
expect {
  "(yes/no)?"
  {send "yes\n";exp_continue}
  "password:"
  {send "[lindex $argv 2]\n";exp_continue}
  ":~"
  {send "su\n";exp_continue}
  "Password:"
  {send "[lindex $argv 3]\ncd /faronear\n"}
#  "密码："
#  {send "[lindex $argv 3]\ncd /faronear\n"}
}
interact
