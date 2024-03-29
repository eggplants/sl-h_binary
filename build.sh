#!/usr/bin/env bash

set -euo pipefail
set -x

# Ubuntu: apt update && apt install build-essential curl libncurses5-dev -y
# Mac: brew update && brew install curl gcc ncurses make

if ! command -v curl gcc make &> /dev/null; then
  echo "require: build-essential curl libncurses5-dev" >&2
  exit 1
elif ! [[ -f '/usr/include/ncurses.h' || -d '/usr/local/Cellar/ncurses' ]]; then
  echo "require: ncurses" >&2
  exit 1
fi

# sl (2.02)
curl -Lo sl.tar 'https://web.archive.org/web/20070220170601if_/http://www.tkl.iis.u-tokyo.ac.jp:80/~toyoda/sl/sl.tar' 
tar xopf sl.tar
(
  cd sl
  # sl-h (sl5-1.patch)
  curl -Lo sl5-1.patch 'https://web.archive.org/web/20090316133609/http://www.izumix.org.uk:80/sl/sl5-1.patch'
  patch -p1 < sl5-1.patch
  sed s_ncurses/__ sl.c > _
  mv _ sl.c
  make && mv sl ../sl-h
)
rm -rf sl sl.tar
echo "done! Try: ./sl-h"
