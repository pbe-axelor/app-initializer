#!/bin/bash
#
# 
#

set -e

[ -d "/tmp/app-initializer" ] && rm -rf /tmp/app-initializer*

wget -q -O /tmp/app-initializer.tar.gz \
  "https://github.com/pbe-axelor/app-initializer/archive/main.tar.gz"

mkdir -p /tmp/app-initializer/template
tar xzf /tmp/app-initializer.tar.gz -C /tmp/app-initializer/template --strip-components=1

/tmp/app-initializer/template/create.sh "$@"

rm -rf /tmp/app-initializer*