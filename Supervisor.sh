#!/bin/bash
apt install -y epel-release
apt install -y supervisor

# 备份配置文件，新增个性化配置（无配置则使用默认配置）
if [ ! -f "/etc/supervisor/supervisord.example.conf" ]; then
  mv -fu /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.example.conf
fi

cat <<EOF >/etc/supervisor/supervisord.conf
[unix_http_server]
file=/var/run/supervisor/supervisor.sock

[inet_http_server]
port=0.0.0.0:11911
username=root
password=root

[supervisord]
logfile=/var/log/supervisor/supervisord.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info
pidfile=/var/run/supervisord.pid
nodaemon=false
minfds=1024
minprocs=200

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor/supervisor.sock

[include]
files = /etc/supervisor/conf.d/*.ini
EOF

# 设置开机自启
systemctl enable supervisord
