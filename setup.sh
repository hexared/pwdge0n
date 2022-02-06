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

cat <<EOF
Which version do you want to install?

1) sh
2) python
EOF

printf >&2 "\nOption: "
read -r RES

case $RES in
1 | sh)
	EXTENSION="sh"
	;;
2 | python)
	PYTHON=$(command python3)
	if [ -z $PYTHON ]; then
		printf >&2 "You need to install python3 first.\nWanna set up sh version?[Y/n] "
		read -r R
		case $R in
		n | N | no | NO)
			exit 1
			;;
		y | Y | yes | YES | *)
			EXTENSION="sh"
			;;
		esac
	else
		EXTENSION="py"
	fi
	;;
*)
	printf >&2 "Please, choose one of the listed options."
	exit 1
	;;
esac

chmod +x "./pwdge0n.$EXTENSION"
ln -s "$PWD"/"pwdge0n.$EXTENSION" /usr/local/bin/pwdg || EXISTS=1
if ! [ -z $EXISTS ]; then
	AEXT=$(ls -l /usr/local/bin/pwdg | tr "." "\n" | tail -n1)
	case $AEXT in
	py)
		VERSION="python"
		;;
	sh)
		VERSION="sh"
		;;
	*)
		VERSION="an unrecognized ($AEXT)"
		;;
	esac
	printf >&2 "You have $VERSION version installed."
	printf >&2 "Do you want to substitute the actual version?[Y/n] "
	read -r R
	case $R in
	n | N | no | NO)
		printf >&2 "Ok then. Bye!"
		exit 0
		;;
	y | Y | yes | YES | *)
		rm -r /usr/local/bin/pwdg
		ln -s "$PWD"/"pwdge0n.$EXTENSION" /usr/local/bin/pwdg
		;;
	esac
fi
printf >&2 "Done.\n"
pwdg
