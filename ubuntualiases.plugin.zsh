alias ai='sudo apt install'
alias au='sudo apt update'
alias aup='sudo apt upgrade'
alias ar='sudo apt remove'
alias aar='sudo apt autoremove'
alias as='apt search'

appa() {
  sudo add-apt-repository ppa:$1
}

COLOR_GREEN='\033[0m\033[1m\033[32m'
COLOR_YELLOW='\033[0m\033[1m\033[33m'
COLOR_BLUE='\033[0m\033[1m\033[34m'
COLOR_LIGHT_BLUE='\033[0m\033[34m'
COLOR_RESET='\033[0m'
asi () {
  _search=$(apt-cache search $@)

  if [[ "${_search}" == "" ]]; then
    return
  fi

  i=1
  echo ${_search} | \
    while read line; do
      if $(dpkg-query --status $(echo $line | awk '{print $1}') &>/dev/null); then
        ins="$COLOR_GREEN [Installed]$COLOR_RESET"
      else
        ins=""
      fi

      echo $line $ins | \
        awk -v yl="$COLOR_YELLOW" -v bl="$COLOR_BLUE" -v lbl="$COLOR_LIGHT_BLUE" -v rst="$COLOR_RESET" -v i=$i -F' - ' \
            '{num=(yl i ") "); $1=(bl $1 lbl); print num $0 rst}'
      ((i++))
    done

  echo -n "Choose package: " && read _pkg_num
  if [[ ${_pkg_num} =~ [[:digit:]]+ ]]; then
    sudo apt install $(echo ${_search} | sed -n ${_pkg_num}p | awk '{print $1}')
  fi
}
