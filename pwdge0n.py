#!/usr/bin/python3
'''
# SPDX-License-Identifier: GPL-3.0-only
#
# This file is part of the pwdge0n project: https://github.com/j4ckr3d/pwdge0n
#
# Copyright (C) 2021 pwdge0n contributors
#
# pwdge0n is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# pwdge0n is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pwdge0n; if not, see <http://www.gnu.org/licenses/>.

    File name: pwdge0n.py
    Author: Matteo Pernarella
    Date created: 20/01/2022
    Date last modified: 20/01/2022
'''

import random
import sys

# Character used to build the password
lower=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
upper=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
numbers=["0","1","2","3","4","5","6","7","8","9"]
symbols=["~",".",":","-","_",",",";","<",">","\"","|","!","\\","£","$","%","&","/","(",")","=","?","^","+","*","§","@","#","[","]","#","{","}"]
red_symbols=["-","_","|","!","£","$","%","&","=","?","^","+","*","§","@","#","#"]

charlist=[lower, upper, numbers, symbols]

def genpass(n: str) -> str:
    """
    Main function used to generate password

    Parameters:
    ___________

    n : str
        length of the output password
    """
    if "-e" in sys.argv:
        charlist[3]=red_symbols
    if "-a" in sys.argv:
        charlist.pop(3)

    pw=""
    for i in range(0, int(n)):
        ind=random.randint(0, len(charlist)-1)
        jind=random.randint(0, len(charlist[ind])-1)
        pw+=charlist[ind][jind]

    return(pw)

def checker(pw:str) -> bool:
    """
    Utility function used to check if the password contains at least one char of each category

    Parameters:
    ___________

    pw : str
        password to check
    """
    res = True
    for i in range(0, len(charlist)-1):
        if res:
            res = any(c in pw for c in charlist[i])
    return res

def show_help():
    print(f"Usage:\n\n\
\
    {sys.argv[0]} [-e | -a] <password_length>\n\n\
\
Options: \n\n\
\
    -e:     Exclude ambiguous symbols (eg: ' \" \` ~ , ; : . < > {{ }} ( ) [] )\n\
    -a:     Alphanumeric only (uppercase, lowercase and numbers only)\n\n\
\
PASSWORD LENGTH MUST BE >= 8\n")


if __name__ == "__main__":
    print(f"dbg: {sys.argv[0]}")
    pw=""
    pos = 1
    if ("-e" in sys.argv and "-a" in sys.argv) or "-ea" in sys.argv or "-ae" in sys.argv:
        print("You can't use both -e and -a togheter.\n")
        show_help()
        exit(1)
    if "-h" in sys.argv:
        show_help()
        exit(0)
    if "-e" in sys.argv and sys.argv[1] == "-e":
        pos += 1

    if "-a" in sys.argv and sys.argv[1] == "-a":
        pos += 1
    try:
        if int(sys.argv[pos]) < 8:
            show_help()
            exit(1)
        pw = genpass(sys.argv[pos])
    except:
        show_help()
        exit(1)

    while not checker(pw):
        pw=genpass(sys.argv[pos])
    print(pw)
