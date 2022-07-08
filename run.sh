#!/bin/env sh

# POSIX-compliant script for setting up your shell
thisdir=$(dirname $0)
source ${thisdir}/.pyenv-source.txt

# special command: shell
if test "$1" = "shell"
then
  pyenv shell
fi

# run the command if pdm is installed
if test -n "$1"
then
  if command -v pdm &> /dev/null
  then
    pdm "$@"
  else
    ERROR=1
  fi
fi

if test $ERROR
then
  echo "Some error happened! Have you run `install.sh`?"
  exit 1
fi
