#!/bin/env sh

# POSIX-compliant script for setting up your shell
thisdir=$(dirname $0)

# check if this pyenv is already loaded
pyenv_bin=$(which pyenv 2> /dev/null)
should_be_pyenv_bin=$(realpath ${thisdir}/bin/pyenv)
if test "$pyenv_bin" != "$outer_shell"
then
  # setup pyenv
  export PYENV_ROOT=${thisdir}/pyenv
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
else
  ERROR=1
fi

# special command: shell
if test "$1" = "shell"
then
  pyenv shell
  exit
end

# run the command if pdm is installed
if command -v pdm &> /dev/null
then
  pdm $@
else
  ERROR=1
fi

if test $ERROR
then
  echo "Some error happened! Have you run `install.sh`?"
  exit 1
fi
