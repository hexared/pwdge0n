# Pwdge0n
> A simple password generator written in:
    * POSIX shell
    * Python3

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Installation

OS X & Linux:

```sh
# sh setup.sh
```
or

```sh
$ sudo sh setup.sh
```

## Usage

```sh
Usage:

    pwdg [-e | -a] <password_length>

Options:

    -e:     Exclude ambiguous symbols (eg: ' \" \` ~ , ; : . < > { } ( ) [] )
    -a:     Alphanumeric only (uppercase, lowercase and numbers only)

```
it will output a password containing at least one symbol of each category:
 - lowercase letters
 - uppercase letters
 - symbols

`-e` option will exclude some ambiguous characters such as:
```
' " ` ~ , ; : . < > { } [ ] ( )
```
`-a` option will exclude symbol characters and will create an alphanumeric password

### Warning: The password length must be at least 8 characters.
