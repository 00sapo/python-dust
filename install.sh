#!/bin/env sh
thisdir=$(realpath $(dirname $0))

# cloning pyenv
LOCALREPO=${thisdir}/pyenv
REPOSRC=https://github.com/pyenv/pyenv.git

cd $LOCALREPO
# cloning while keeping our files
git init 2> /dev/null
if test ! $?
then
  git pull 2> /dev/null
else
  git remote add origin $REPOSRC
  git fetch
  git checkout origin/master -ft
fi
cd ${thisdir}

# run setup script
source ${thisdir}/pyenv/pyenv-source.sh $thisdir

# install the python version
version=$1
if test -z $version
then
  if test ! -f ${thisdir}/.python-version
  then
    echo "Please, provide the Python version to be installed!"
    exit
  fi
  version=$(cat ${thisdir}/.python-version)
fi

working_dir=$(pwd)
cd $thisdir

pyenv install $1

# set python version
pyenv local $1

# upgrade pip
python -m pip install -U pip

# set dust mode
mode=$(cat ${thisdir}/.dust-mode 2>/dev/null)
if test -n $mode
then
  mode="pdm"
  echo $mode > ${thisdir}/.dust-mode
fi

# install build dependencies
case "$mode" in
 "pip") 
    if test -f "requirements.txt"
    then
      python -m pip install -r requirements.txt;
    fi
    exit
    ;;
 "pdm")
    # install pdm
    python -m pip install -U pdm

    # force pdm to use PEP 582
    if test ! -d .venv && test ! -d __pypackages__
    then
      mkdir __pypackages__
    fi

    # select python version for pdm
    pdm use $(pyenv which python)

    # setup other dependencies
    if test -f "pdm.lock"
    then
      pdm sync
    elif test -f "pyproject.toml"
    then
      pdm lock
      pdm sync
    else
      pdm init
    fi
    if test -f "requirements.txt"
    then
      pdm import -f requirements requirements.txt
    fi
    ;;
  *)
esac

# installation check
echo "-------------------"
echo "-------------------"
echo "Installation Check:"
found_python=$(pyenv exec which python)
case "$found_python" in
  $(realpath $thisdir)/pyenv/*)
    echo "OK!"
    exit 0
    ;;
  *)
    echo "ERROR!"
    exit 1
    ;;
esac
cd $pwd
