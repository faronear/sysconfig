#!/usr/bin/expect

# Usage: expect this.sh [0:hostname] [1:username] [2:pwdadot] [3:pwdroot]

set timeout 10
spawn ssh [lindex $argv 1]@[lindex $argv 0] -p 22
expect {
  "yes/no"
  {send "yes\n";exp_continue}
  "password:"
  {send "[lindex $argv 2]\n";exp_continue}
  ":~"
  {send "su\n";exp_continue}
  "Password:"
  {send "[lindex $argv 3]\ncd /faronear\n"}
  "密码："
  {send "[lindex $argv 3]\ncd /faronear\n"}
}
interact
