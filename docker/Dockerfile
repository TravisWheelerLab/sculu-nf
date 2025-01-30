FROM rust:1.84 AS builder
RUN apt-get update && apt-get install -y git cmake
#WORKDIR /usr/src
RUN git clone https://github.com/TravisWheelerLab/sculu-rs.git sculu
#RUN cargo install --path .
#WORKDIR /usr/src/sculu
RUN cd sculu && cargo build --release && cp target/release/sculu /usr/local/bin

FROM debian:trixie-slim
COPY --from=builder /usr/local/bin /usr/local/bin

#RUN apt-get update && apt-get install -y wget
RUN wget https://www.repeatmasker.org/rmblast/rmblast-2.14.1+-x64-linux.tar.gz

CMD ["sculu"]
