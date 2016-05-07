#!/usr/bin/expect  

set user 
set 

set password  

set token [lindex $argv 1] 

set file [lindex $argv 0] 

set server  

set password2 

spawn ftp ${gate} 

expect "Username*:" 

send "${user}\r" 

expect "Password:" 

send "${password}${token}\r" 

expect "ftp>" 

send "user ${server}\r" 

expect "Password:" 

send "${password2}\r" 

expect "ftp>" 

send "pwd\r" 

expect "ftp>" 

send "cd $path/\r" 

expect "ftp>" 

send "put ${file}\r" 

expect "ftp> " 

send "bye" 
