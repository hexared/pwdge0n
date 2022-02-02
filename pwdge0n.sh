#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
#
# This file is part of the distrobox project: https://github.com/89luca89/distrobox
#
# Copyright (C) 2021 distrobox contributors
#
# distrobox is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3
# as published by the Free Software Foundation.
#
# distrobox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with distrobox; if not, see <http://www.gnu.org/licenses/>.

trap '[ "$?" -ne 0 ] && printf "Error: An error occurred\n"' EXIT

show_help() {
	cat <<EOF

Usage:

    $0 [-e | -a] <password_length>

Options:

    -e:     Exclude ambiguous symbols (eg: ' \" \` ~ , ; : . < > { } ( ) [] )
    -a:     Alphanumeric only (uppercase, lowercase and numbers only)

PASSWORD LENGTH MUST BE >= 8
EOF
	exit 0
}

if [ $# -gt 3 ]; then
	echo "Too many arguments.\n"
	show_help
	exit 1
elif [ $# -lt 1 ]; then
	echo "You must specify at least one argument (the pasword length for example...).\n"
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
	-h)
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
		if [ -z $LENGTH ] && [ -n $1 ]; then
			if ! [ -z $(grep "[0-9]" <<<$1) ]; then
				if [ $1 -gt 7 ]; then
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
	RAND=$((RANDOM % ${#1} / 2))
	for i in $1; do
		if [ $INDEX -eq $RAND ]; then
			printf "%s" "$i"
		fi
		INDEX=$((INDEX + 1))
	done
}

# Check that passowrd contains at least one char of every group
checkpass() {
	for i in [a-z] [A-Z] [0-9]; do
		GOOD=$(grep "$i" <<<$A)
		if [ -z $GOOD ]; then
			GOOD=0
			return 1
		fi
	done
	if [ $MAX -eq 4 ]; then
		GOOD=$(grep "[[:punct:]]" <<<$1)
		if [ -z $GOOD ]; then
			return 1
		fi
	fi
	return 0
}

# Main function used to generate password
genpass() {
	for i in $(seq 1 $LENGTH); do
		case $((RANDOM % MAX)) in
		0)
			CHAR=$(extract "$LOWER")
			;;
		1)
			CHAR=$(extract "$UPPER")
			;;
		2)
			CHAR=$(extract "$NUMBERS")
			;;
		3)
			if [ $E -gt 0 ]; then
				CHAR=$(extract "$RSYMBOLS")
			else
				CHAR=$(extract "$SYMBOLS")
			fi
			;;
		esac
		PASSWORD="$PASSWORD$CHAR"
	done
	checkpass "$PASSWORD"
	if ! [ -z $? ]; then
		printf "%s\n" "$PASSWORD"
	else
		genpass
	fi
}

genpass
