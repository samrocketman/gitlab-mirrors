#COLORS DOCUMENTATION
# black - 30
# red - 31
# green - 32
# brown - 33
# blue - 34
# magenta - 35
# cyan - 36
# lightgray - 37
# 
# * 'm' character at the end of each of the following sentences is used as a stop character, where the system should stop and parse the \033[ sintax.
# 
# \033[0m - is the default color for the console
# \033[0;#m - is the color of the text, where # is one of the codes mentioned above
# \033[1m - makes text bold
# \033[1;#m - makes colored text bold**
# \033[2;#m - colors text according to # but a bit darker
# \033[4;#m - colors text in # and underlines
# \033[7;#m - colors the background according to #
# \033[9;#m - colors text and strikes it
# \033[A - moves cursor one line above (carfull: it does not erase the previously written line)
# \033[B - moves cursor one line under
# \033[C - moves cursor one spacing to the right
# \033[D - moves cursor one spacing to the left
# \033[E - don't know yet
# \033[F - don't know yet
# 
# \033[2K - erases everything written on line before this.

#Colors variables
SETCOLOR_GREEN="echo -en \\033[0;32m"
SETCOLOR_RED="echo -en \\033[0;31m"
SETCOLOR_YELLOW="echo -en \\033[0;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
SETSTYLE_BOLD="echo -en \\033[1m"
SETSTYLE_UNDERLINE="echo -en \\033[4m"
SETSTYLE_NORMAL="echo -en \\033[0m"

enable_colors="${enable_colors:-true}"

#same as echo function except the whole text line is red
function red_echo() {
  #in order for the -n functionality to work properly $2 must be quoted when called in case of spaces
  if "${enable_colors}";then
    if [ "$1" = "-n" ];then
      ${SETCOLOR_RED} && echo -n "$2" && ${SETCOLOR_NORMAL}
    else
      ${SETCOLOR_RED} && echo "$*" && ${SETCOLOR_NORMAL}
    fi
  else
    if [ "$1" = "-n" ];then
      echo -n "$2"
    else
      echo "$*"
    fi
  fi
}

#same as echo function except the whole text line is green
function green_echo() {
  #in order for the -n functionality to work properly $2 must be quoted when called in case of spaces
  if "${enable_colors}";then
    if [ "$1" = "-n" ];then
      ${SETCOLOR_GREEN} && echo -n "$2" && ${SETCOLOR_NORMAL}
    else
      ${SETCOLOR_GREEN} && echo "$*" && ${SETCOLOR_NORMAL}
    fi
  else
    if [ "$1" = "-n" ];then
      echo -n "$2"
    else
      echo "$*"
    fi
  fi
}

#same as echo function except the whole text line is yellow
function yellow_echo() {
  #in order for the -n functionality to work properly $2 must be quoted when called in case of spaces
  if "${enable_colors}";then
    if [ "$1" = "-n" ];then
      ${SETCOLOR_YELLOW} && echo -n "$2" && ${SETCOLOR_NORMAL}
    else
      ${SETCOLOR_YELLOW} && echo "$*" && ${SETCOLOR_NORMAL}
    fi
  else
    if [ "$1" = "-n" ];then
      echo -n "$2"
    else
      echo "$*"
    fi
  fi
  return 0
}

#same as echo function except output bold text
function bold_echo() {
  #in order for the -n functionality to work properly $2 must be quoted when called in case of spaces
  if "${enable_colors}";then
    if [ "$1" = "-n" ];then
      ${SETSTYLE_BOLD} && echo -n "$2" && ${SETSTYLE_NORMAL}
    else
      ${SETSTYLE_BOLD} && echo "$*" && ${SETSTYLE_NORMAL}
    fi
  else
    if [ "$1" = "-n" ];then
      echo -n "$2"
    else
      echo "$*"
    fi
  fi
  return 0
}

#same as echo function except output underlined text
function underline_echo() {
  #in order for the -n functionality to work properly $2 must be quoted when called in case of spaces
  if "${enable_colors}";then
    if [ "$1" = "-n" ];then
      ${SETSTYLE_UNDERLINE} && echo -n "$2" && ${SETSTYLE_NORMAL}
    else
      ${SETSTYLE_UNDERLINE} && echo "$*" && ${SETSTYLE_NORMAL}
    fi
  else
    if [ "$1" = "-n" ];then
      echo -n "$2"
    else
      echo "$*"
    fi
  fi
  return 0
}
