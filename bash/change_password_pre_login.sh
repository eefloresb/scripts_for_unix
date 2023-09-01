#!/usr/bin/expect

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores@canvia.com

#Script que te permite cambiar la contraseña cuando este ha caducado y te pido que insertes 3 veces, la primera la contraseña actual
#Y de ahí las nuevas contraseñas las cuales deben ser identicas
set timeout 10
set user cnveflor
set password CnV./abc66ef
set new_password 3Stud103sc4rl4t41887$.
set SSH /usr/bin/ssh

set f [open "input1.txt"]
set hosts [read $f]
close $f

## need to say if the expected value is "(current) UNIX password: then do this"
foreach host $hosts {
    spawn -noecho $SSH -q -o StrictHostKeychecking=no "$user\@$host"
    expect "$user\@$host\'s password:"
    send "$password\r"
        expect {
            #"(actual) contraseña de UNIX:" {send $password\r; exp_continue}
            "(current) UNIX password:" {send $password\r; exp_continue}
            "Enter new UNIX password:" {send $new_password\r; exp_continue}
            "Retype new UNIX password:" {send $new_password\r; exp_continue}
            "~]$" {close}
        }
    #send "echo -e '$password\n$new_password\n$new_password' | passwd\r"
    #expect "~]$" {close}
}
