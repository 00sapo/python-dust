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
  # change requirements.txt to point towards the intel file on anaconda
  using_intel=$(grep "url = \"https://pypi.anaconda.org/intel/simple\"" pyproject.toml 2>&1 1>/dev/null)
  if test "$?"
  then
    intel_packages='numpy scipy numba'
    # intel also offers tesorflow but only for very old python (3.6)
    for package in $intel_packages:
    do
      version=$(grep -zoP "name = \"$package\"\nversion = \"\K.*(?=\")" pdm.lock | tr -d '\0')
      pv=$(pyenv exec python --version | grep -oP 'Python 3.\K.')
      unameOut="$(uname -s)"
      case "${unameOut}" in
          Linux*)     os='manylinux2014';;
          *)          continue;;
      esac
      echo ${machine}
      sed -i "/$package.*/c\https:\/\/pypi.anaconda.org\/intel\/simple\/$package\/$version\/$package-$version-0-cp3$pv-cp3$pv-${os}_x86_64.whl" requirements.txt
    done
  fi

  # installing from requirements
  pyenv exec python -m pip install --upgrade -r requirements.txt
}

dust_sync() {
  dust_pdm_export
  dust_pip_install
}

setup_intel_mirrors() {
  echo -e "${BGreen}${On_Black}Setting-up intel mirrors!$NC"
  cat dustenv/intel_mirrors.toml >> pyproject.toml
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
  if test -z "$option"
  then
    option="n"
  fi
  if test $option = "y" || test $option = "Y"
  then
    return 0
  else
    return 1
  fi
}

run_hook() {
  hook_dir="${DUSTDIR}/${1}.d/"
  if test -d "$hook_dir"
  then
    for i in $(ls $hook_dir/*.sh)
    do
      sh $i
    done
  fi
}
