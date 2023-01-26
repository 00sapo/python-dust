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

setup_intel_mirrors() {
  echo -e "${BGreen}${On_Black}Setting-up intel mirrors!$NC"
  cat pyproject.toml dustenv/intel_mirrors.toml > pyproject.toml
}

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC='\033[0m' # No Color

ask_yn() {
  echo -e 
  echo -e
  echo -e -n "${BBlue}${On_White}$@${NC} " >&2
  read -r option
  if test $option = "y" || test $option = "Y"
  then
    return 0
  else
    return 1
  fi
}
