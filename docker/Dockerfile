FROM rust:1.84 AS builder
RUN apt-get update && apt-get install -y git cmake
RUN git clone https://github.com/TravisWheelerLab/sculu-rs.git sculu && \
    cd sculu && \
    cargo build --release && \
    cp target/release/sculu /usr/local/bin

#FROM debian:trixie-slim
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y wget build-essential
#RUN wget https://www.repeatmasker.org/rmblast/rmblast-2.14.1+-x64-linux.tar.gz
WORKDIR /tmp
COPY rmblast-2.14.1+-x64-linux.tar.gz .
RUN  tar xvf rmblast-2.14.1+-x64-linux.tar.gz && \
     cp rmblast-2.14.1/bin/* /usr/local/bin   && \
     rm -rf rmblast-*

#COPY --from=builder /usr/local/bin /usr/local/bin

CMD ["sculu"]
