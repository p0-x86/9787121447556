FROM ubuntu:22.04

LABEL maintainer="Guxiaobai <sikuan.gu@gmail.com>"

RUN sed -i -r 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN apt-get update -y

# bochs
RUN apt-get install -y --no-install-recommends bochs bochs-x bximage

# complie
RUN apt-get install -y --no-install-recommends build-essential gdb nasm make

WORKDIR /usr/src/app