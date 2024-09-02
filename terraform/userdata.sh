#! /bin/sh
apt update -y
apt install golang git libenet-dev -y
# mkdir /tmp/ssm
# wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
# sudo systemctl enable amazon-ssm-agent
# sudo systemctl start amazon-ssm-agent
# sudo dpkg -i amazon-ssm-agent.deb
# cd /tmp/ssm
export HOME=/home/ubuntu
export GOCACHE=$HOME/.cache/go-build
mkdir -p $GOCACHE
git clone ${git_url}
cd ${path}/src
go build -o test
./test


