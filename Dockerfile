FROM ubuntu:latest
ENV ROOT_PATH=/home/otg/models-yang
ENV GOPATH=/home/go
ENV PATH=${PATH}:/usr/local/go/bin:${GOPATH}/bin
RUN mkdir -p ${ROOT_PATH}
# Get project source, install dependencies and build it
COPY . ${ROOT_PATH}/
RUN cd ${ROOT_PATH} && chmod +x ./do.sh && ./do.sh deps && ./do.sh art 2>&1
WORKDIR ${ROOT_PATH}
CMD ["/bin/bash"]
