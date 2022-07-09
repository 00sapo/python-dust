#!/bin/env sh

thisdir=$(dirname $0)

# cloning pyenv
LOCALREPO=${thisdir}/pyenv
REPOSRC=https://github.com/pyenv/pyenv.git
git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull

# run setup script
source ${thisdir}/.pyenv-source.sh $thisdir

# install the python version
if test -z $1
then
  echo "Please, provide the Python version to be installed!"
  exit
fi

working_dir=$(pwd)
cd $thisdir

pyenv install $1

# set python version
pyenv local $1

# upgrade pip
pyenv exec python -m pip install -U pip

if test -f "requirements.txt"
then
  pyenv exec python -m pip install -r requirements.txt
  exit
fi

# install pdm
pyenv exec python -m pip install -U pdm

# force pdm to use PEP 582
if test ! -d .venv
then
  mkdir __pypackages__
fi

# select python version for pdm
pdm use $(pyenv which python)

# sync
pdm sync
cd $pwd
