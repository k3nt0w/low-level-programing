FROM debian:8

RUN apt-get update \
  apt-get install -y binutils nasm gdb \
  apt-get install -y vim
