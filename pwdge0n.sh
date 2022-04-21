#!/bin/sh
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

trap '[ "$?" -ne 0 ] && printf "Error: An error occurred\n"' EXIT

show_help() {
	cat <<EOF

Usage:

    pwdge0n [-e | -a] <password_length>

Options:

    -e:     Exclude ambiguous symbols (eg: ' \" \` ~ , ; : . < > { } ( ) [] )
    -a:     Alphanumeric only (uppercase, lowercase and numbers only)

PASSWORD LENGTH MUST BE >= 8
EOF
	exit 0
}

if [ $# -gt 3 ]; then
	printf >&2 "Too many arguments.\n"
	show_help
	exit 1
elif [ $# -lt 1 ]; then
	printf >&2 "You must specify at least one argument (the pasword length for example...).\n"
	show_help
	exit 1
fi

# Character used to build the password
LOWER="a b c d e f g h i j k l m n o p q r s t u v w x y z "
UPPER="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z "
NUMBERS="0 1 2 3 4 5 6 7 8 9 "
SYMBOLS="~ . : - _ ; < > | ! \\ £ $ % & / ( ) = ? ^ + * § @ # \" # { }"
RSYMBOLS="- _ | ! £ $ % & = ? ^ + * § @ # "
MAX=4
E=0

# Arguments parsing
while :; do
	case $1 in
	-h | --help)
		show_help
		;;
	-e)
		E=1
		shift
		;;
	-a)
		MAX=3
		shift
		;;
	*)
		if [ -z "${LENGTH}" ] && [ -n "$1" ]; then
			if [ -n $(echo "$1" | grep "[0-9]") ]; then
				if [ "$1" -gt 7 ]; then
					LENGTH=$1
					shift
				else
					show_help
				fi
			else
				show_help
			fi
		else
			break
		fi
		;;
	esac
done

# Extract character from one of the array
extract() {
	INDEX=0
	RNDM=$(od -vAn -N4 -t u4 </dev/urandom)
	RAND=$((RNDM % ${#1} / 2))
	for i in $1; do
		if [ ${INDEX} -eq ${RAND} ]; then
			printf "%s" "$i"
		fi
		INDEX=$((INDEX + 1))
	done
}

# Check that passowrd contains at least one char of every group
checkpass() {
	for i in [a-z] [A-Z] [0-9]; do
		GOOD=$(echo "$1" | grep "$i")
		if [ -z "${GOOD}" ]; then
			GOOD=0
			return 1
		fi
	done
	if [ ${MAX} -eq 4 ]; then
		GOOD=$(echo "$1" | grep "[[:punct:]]")
		if [ -z "${GOOD}" ]; then
			return 1
		fi
	fi
	return 0
}

# Main function used to generate password
genpass() {
	for i in $(seq 1 "${LENGTH}"); do
		RNDM=$(od -vAn -N4 -t u4 </dev/urandom)
		case $((RNDM % MAX)) in
		0)
			CHAR=$(extract "${LOWER}")
			;;
		1)
			CHAR=$(extract "${UPPER}")
			;;
		2)
			CHAR=$(extract "${NUMBERS}")
			;;
		3)
			if [ $E -gt 0 ]; then
				CHAR=$(extract "${RSYMBOLS}")
			else
				CHAR=$(extract "${SYMBOLS}")
			fi
			;;
		esac
		set -o noglob
		PASSWORD="${PASSWORD}${CHAR}"
	done
	if ! [ $(checkpass "${PASSWORD}") ]; then
		printf "%s\n" "${PASSWORD}"
	else
		genpass
	fi
}

genpass
