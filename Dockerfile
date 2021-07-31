FROM ubuntu:20.04

LABEL maintainer="shukri.adams@gmail.com" \
    src="https://github.com/shukriadams/docker-platformio" 

RUN apt-get update \
    && apt-get install git -y \
    && apt-get install python3-minimal -y \
    && apt-get install python3-pip -y \
    && pip install -U platformio==5.1.1 

ENV PATH="/root/.local/bin:${PATH}"