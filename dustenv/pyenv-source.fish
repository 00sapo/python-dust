set PYENVDIR $argv[1]

# check if this pyenv is already loaded
set pyenv_bin (which pyenv 2> /dev/null)
set should_be_pyenv_bin (realpath $PYENVDIR/bin/pyenv)
if test "$pyenv_bin" != "$should_be_pyenv_bin"
  set --export PYENV_ROOT $PYENVDIR
  set --export PATH "$PYENV_ROOT/bin:$PATH"
  fish_add_path $PYENV_ROOT/bin
  status is-login; and pyenv init --path | source
  source (pyenv init - | psub)
end
