#! /bin/sh
apt update -y
apt install golang git -y
export HOME=/home/ubuntu
export GOCACHE=$HOME/.cache/go-build
mkdir -p $GOCACHE
git clone ${git_url}
cd ${path}/src
go build -o test
./test


