# Open-Traffic-Generator Telemetry Yang Models
[![Build](https://github.com/ajbalogh/models-yang/workflows/Build/badge.svg)](https://github.com/ajbalogh/models-yang/actions)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://en.wikipedia.org/wiki/MIT_License)


Helpful links
- https://github.com/openconfig/ygot/blob/master/docs/protobuf_getting_started.md


## Build

Gitlab is not reachable from within lab network, hence please make sure that the intended system is outside lab network (for build to succeed).


- **Clone this project**

  ```sh
  git clone https://github.com/open-traffic-generator/models-yang.git
  cd models-yang/
  ```

- **For Development**

    ```sh
    # Create a tagged docker image
    docker build -t models-yang:dev .
    # Start container and you'll be placed inside the project dir
    docker run -it --name models-yang-dev models-yang:dev
    ```

## Quick Tour

**do.sh** covers most of what needs to be done manually. In addition, **make** utility can be used.

```sh
# install necessary software for dev environment setup and install dependency
./do.sh deps
# build artifacts
./do.sh art
# clean artifacts
./do.sh clean
# run makefile
make
# generate yang tree
make lint
```

Get project source, install dependencies and build it
