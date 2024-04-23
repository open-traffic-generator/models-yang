#!/bin/sh

# Avoid warnings for non-interactive apt-get install
export DEBIAN_FRONTEND=noninteractive

install_deps() {
    apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install curl git python-is-python3 python3-pip \
    && python -m pip install --prefer-binary -r requirements.txt 
}

gen_artifacts() {
    echo "\nGenerating Artifacts ...\n"
    make generate
}

clean() {
    rm -rf artifacts pkg
}

case $1 in
    deps   )
        install_deps
        ;;
    art  )
        gen_artifacts
        ;;
    clean )
        clean
        ;;
    *   )
        $1 || echo "usage: $0 [deps|art|clean]"
        ;;
esac
