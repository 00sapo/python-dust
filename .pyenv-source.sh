thisdir=$(dirname $1)

# check if this pyenv is already loaded
pyenv_bin=$(which pyenv 2> /dev/null)
should_be_pyenv_bin=$(realpath ${thisdir}/pyenv/bin/pyenv)
if test "$pyenv_bin" != "$should_be_pyenv_bin"
then
  # setup pyenv
  export PYENV_ROOT=${thisdir}/pyenv
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init -)"
else
  ERROR=1
fi