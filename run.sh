#!/bin/env sh

# POSIX-compliant script for setting up your shell
thisdir=$(dirname $0)
source ${thisdir}/.pyenv-source.txt

# special command: shell
if test "$1" = "shell"
then
  /bin/env sh
  exit
fi

# check if there is any option
if test -n "$1"
then
  # run the command with pdm if it is installed
  if python -c "import pdm" &> /dev/null
  then
    pdm "$@"
  # run the command with pyenv if there is requirements.txt
  elif test -f "requirements.txt"
      then
        pyenv exec "$@"
  else
    ERROR=1
  fi
fi

if test $ERROR
then
  echo "Some error happened! Have you run 'install.sh'?"
  exit 1
fi
