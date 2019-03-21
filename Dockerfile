FROM debian:8

RUN apt-get update
RUN apt-get install -y binutils nasm gdb 
RUN apt-get install -y vim
