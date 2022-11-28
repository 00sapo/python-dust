dust_pdm_export() {
  pyenv exec pdm export -f requirements --pyproject -o requirements.txt
}

dust_pdm_import() {
  pyenv exec pdm import -f requirements requirements.txt
}

dust_pip_export() {
  pyenv exec python -m pip freeze > requirements.txt 2>/dev/null
}

dust_pip_install() {
  pyenv exec python -m pip install --upgrade -r requirements.txt
}

dust_sync() {
  dust_pdm_export
  dust_pip_install
}

ask_yn() {
  echo -n "$@ " >&2
  read -r option
  if test $option = "y" || test $option = "Y"
  then
    return 0
  else
    return 1
  fi
}
