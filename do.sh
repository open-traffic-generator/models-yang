#!/bin/sh

# Avoid warnings for non-interactive apt-get install
export DEBIAN_FRONTEND=noninteractive

GO_VERSION=1.19

get_go() {
    echo "\nInstalling Go ...\n"
    # install golang per https://golang.org/doc/install#tarball
    curl -kL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
        | tar -C /usr/local/ -xzf -
}

get_go_deps() {
    echo "\nDowloading go dependencies ...\n"
    # for generating Go client stubs from openapi.yaml
    # GO111MODULE=on go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
}

install_deps() {
    apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install curl git python-is-python3 python3-pip \
    && get_go \
    && python -m pip install --prefer-binary -r requirements.txt \
    && get_go_deps
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
