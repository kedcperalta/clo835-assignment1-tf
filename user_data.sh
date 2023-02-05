#! /bin/bash
yum install -y docker
usermod -a -G docker ec2-user
systemctl start docker
systemctl enable docker