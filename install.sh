#!/bin/env sh
thisdir=$(realpath $(dirname $0))
default_version=3.9.16

# cloning pyenv
DUSTDIR=${thisdir}/dustenv
PYENVDIR=${DUSTDIR}/pyenv
REPOSRC=https://github.com/pyenv/pyenv.git

# cloning and pulling (in case we had already cloned)
git clone "$REPOSRC" "$PYENVDIR" 2> /dev/null || git -C "$PYENVDIR" pull

# run setup script
. ${DUSTDIR}/pyenv-source.sh

# import utilities
. ${DUSTDIR}/common.sh

if test "$1" = "list"
then
  pyenv install -l
  exit
fi

# install the python version
setup_intel=0
version=$1
if test -z $version
then
  if test ! -f ${thisdir}/.python-version
  then
    echo -e "${BGreen}${On_Black}Version not provided, using default: $default_version${NC}"
    version=$default_version
    echo $version > ${thisdir}/.python-version
    setup_intel=1
  fi
  version=$(cat ${thisdir}/.python-version)
fi

# install dependencies
. ${DUSTDIR}/dependencies.sh
if ! install_python_dust_dependencies
then
  echo -n "Python dependencies were not installed correctly. Do you want to continue anyway? [y/n] "
  read -r option
  if test $option != "y" && test $option != "Y"
  then
    exit
  fi
fi

working_dir=$(pwd)
cd $thisdir

pyenv install $1

# set python version
pyenv local $1

# upgrade pip
pyenv exec python -m pip install -U pip

# install pdm
pyenv exec python -m pip install -U pdm

# select python version for pdm
pyenv exec pdm use $(pyenv which python)

# install build dependencies
if test ! -f "pyproject.toml"
then
  pyenv exec pdm init --python $(pyenv prefix)/bin/python
fi

# create .venv link
if test -d .venv
then
  # user tried to create a virtualenv in the pdm prompt
  rm -r .venv
fi
if test ! -e .venv
then
  venv_dir=$(realpath --relative-to="${PWD}" "$(pyenv prefix)")
  ln -s "$venv_dir" .venv
fi

if test setup_intel
then
  setup_intel_mirrors
fi

# installation check
echo "-------------------"
echo "-------------------"
echo "Installation Check:"
found_python=$(pyenv exec which python)
case "$found_python" in
  $(realpath $PYENVDIR)*)
    echo -e "$BGreen OK! $NC"
    exit 0
    ;;
  *)
    echo -e "$BRed ERROR! $NC"
    exit 1
    ;;
esac
cd $pwd
