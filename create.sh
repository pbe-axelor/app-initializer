#!/bin/bash

set -e

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LATEST_VERSION="7.0"
DEST_DIR=$(pwd)

usage()
{
cat << EOF
usage: ./create.sh --name <name> [--version <version>]
--name        (Required)     The project name
--version        (Mandatory)    The version used
--module-name        (Mandatory)    If wanted a custom module, the name of that module
-h | --help                  Brings up this menu
EOF
}

CYAN='\033[0;36m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[31m'
NC='\033[0m'

PROJECT_NAME="${APP_INITIALIZER_PROJECT_NAME}"
BASE_VERSION="${APP_INITIALIZER_BASE_VERSION}"
MODULE_NAME="${APP_INITIALIZER_MODULE_NAME}"

while [ "$1" != "" ]; do
    case $1 in
        --name )
            shift
            PROJECT_NAME=$1
            ;;
        --version )
            shift
            BASE_VERSION=$1
            ;;
        --module-name )
            shift
            MODULE_NAME=$1
            ;;
        -h | --help )
            usage
            exit
            ;;
        * ) usage
            exit 1
            ;;
    esac
    shift
done

BASE_VERSION=${BASE_VERSION:-$LATEST_VERSION}
PROJECT_DIR="${DEST_DIR}/${PROJECT_NAME}"

check() {

    # Check if project name is provided
    if [ -z "${PROJECT_NAME}" ]; then
        echo -e "${RED}project name parameter is required, provide it with the flag --name OR the variable \$PROJECT_NAME${NC}"
        exit 1
    fi

    if [ ! -d "${BASE_DIR}/${BASE_VERSION}" ]; then
        echo -e "${RED}version ${BASE_VERSION} don't exist, use on of $(find "${BASE_DIR}"/* -maxdepth 1 -type d | awk -F"./" '{print $6}' | tr '\n' ', ')${NC}"
        exit 1
    fi

    if [ -d "${PROJECT_DIR}" ]; then
        echo -e "${RED}${PROJECT_DIR} already exist${NC}"
        exit 1
    fi

}

var_value() {
    eval echo \$$1
}

update_template() {
  local FILE=${1?missing argument}
  shift

  [[ ! -f ${FILE} ]] && return 1

  local VARIABLES=($@)

  for variable in ${VARIABLES[@]}; do
    value=$(echo `var_value $variable` | sed 's/\//\\\//g');
    sed -i "s/{{\s*$variable\s*}}/$value/g" "${FILE}"
  done
}

create_project() {
    cp -r "${BASE_DIR}/${BASE_VERSION}" "${PROJECT_DIR}"

    AOS_VERSION=$(wget https://raw.githubusercontent.com/axelor/axelor-open-suite/${BASE_VERSION}/version.txt -q -O - || true)

    update_template "${PROJECT_DIR}/build.gradle" \
        PROJECT_NAME AOS_VERSION
    update_template "${PROJECT_DIR}/settings.gradle" \
        PROJECT_NAME
    update_template "${PROJECT_DIR}/README.md" \
        PROJECT_NAME
}

adjust_module() {
    if [ -z "${MODULE_NAME}" ]; then
      rm -rf "${PROJECT_DIR}/modules"
      return 0
    fi

    mv "${PROJECT_DIR}/modules/my-module" "${PROJECT_DIR}/modules/${MODULE_NAME}"

    update_template "${PROJECT_DIR}/modules/${MODULE_NAME}/build.gradle" \
        MODULE_NAME

}

end() {
    echo -e "${GREEN}${PROJECT_NAME} project has been initialized in ${PROJECT_DIR}${NC}"
}

check
create_project
adjust_module
end