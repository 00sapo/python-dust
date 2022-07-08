#!/bin/env sh

thisdir=$(dirname $0)

# cloning pyenv
LOCALREPO=${thisdir}/pyenv
REPOSRC=https://github.com/pyenv/pyenv.git
git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull

# check parent process and run setup script
outer_shell=$(cat /proc/$PPID/comm)
if test "$outer_shell" = fish
then 
  ${thisdir}/setup.fish
else 
  ${thisdir}/setup.sh
fi

# install the python version
if test -z $1
then
  echo "Please, provide the Python version to be installed!"
  exit
fi

pyenv install $1

# set python version
pyenv local $1

# install pdm
pyenv exec python -m pip install -U pdm

# force pdm to use PEP 582
if test ! -d .venv
then
  mkdir __pypackages__
fi

# select python version for pdm
pdm use $(pyenv which $1)

# sync
pdm sync
