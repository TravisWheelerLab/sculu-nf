#FROM rust:1.84 AS builder
#RUN apt-get update && apt-get install -y git cmake

#FROM debian:trixie-slim
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y wget build-essential git cmake curl vim

# Install rmblastn binaries
RUN wget -q https://www.repeatmasker.org/rmblast/rmblast-2.14.1+-x64-linux.tar.gz && \
    tar xf rmblast-2.14.1+-x64-linux.tar.gz && \
    cp rmblast-2.14.1/bin/* /usr/local/bin  && \
    rm -rf rmblast-*

# Install RepeatModeler/RepeatMasker
WORKDIR /usr/local/perl
RUN wget -q -O RepeatModeler.tgz \
    https://github.com/Dfam-consortium/RepeatModeler/archive/refs/tags/2.0.6.tar.gz && \
    tar xf RepeatModeler.tgz && \
    mv RepeatModeler-2.0.6 RepeatModeler && \
    wget -q -O RepeatMasker.tgz \
    https://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.1.6.tar.gz && \
    tar xf RepeatMasker.tgz && \
    rm RepeatMasker.tgz RepeatModeler.tgz
ENV PATH=/usr/local/perl/RepeatModeler:/usr/local/perl/RepeatModeler/util:$PATH
ENV PERL5LIB=/usr/local/perl/RepeatModeler:/usr/local/perl/RepeatMasker

# Install Rust
RUN curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | bash -s -- -y 
ENV PATH=/root/.cargo/bin:$PATH

# Install SCULU
WORKDIR /usr/local
RUN git clone --quiet https://github.com/TravisWheelerLab/sculu-rs.git sculu && \
    cd sculu && \
    cargo install --quiet --path .

#COPY --from=builder /usr/local/bin /usr/local/bin
CMD ["sculu"]
