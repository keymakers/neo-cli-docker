# Getting Base Image
FROM ubuntu:16.04

# Author Info
MAINTAINER ____easy

RUN apt-get update
RUN apt-get install -y curl

# install nginx
RUN touch /etc/apt/sources.list.d/nginx.list
RUN echo "deb http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-get update
RUN apt-get install -y nginx

# install needed tools
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y libleveldb-dev sqlite3 libsqlite3-dev
RUN apt-get install -y libunwind8

# set working directory
WORKDIR /root

# install dotnet-sdk
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get install -y apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.1

# download neo-cli
RUN git clone https://github.com/neo-project/neo-cli.git

# start-up neo-cli
RUN cd neo-cli && \
    dotnet restore && \
    dotnet publish -c release -r linux-x64

# setting to connect to testnet
#RUN cd ~/neo-cli/neo-cli/bin/Release/netcoreapp2.0/linux-x64 && \
#	wget http://sync.ngd.network/testnet/full/chain.acc.zip && \
#	rm config.json protocol.json && \
#	mv config.testnet.json config.json && \
#	mv protocol.testnet.json protocol.json

# setting to connect to mainnet
RUN cd ~/neo-cli/neo-cli/bin/Release/netcoreapp2.0/linux-x64 && \
        wget http://sync.ngd.network/mainnet/full/chain.acc.zip 

# Port
EXPOSE 22 80 10332

# change config file of nginx
COPY ./config/nginx.conf /etc/nginx/

