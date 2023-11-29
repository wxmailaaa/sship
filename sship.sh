#!/bin/bash

# 更新软件包列表并安装fail2ban
sudo apt update -y && apt install -y fail2ban

# 执行一些命令
systemctl start fail2ban
systemctl enable fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local


# 指定文件路径
file_path="/etc/fail2ban/jail.local"

# 要替换的字符串
old_string="bantime  = 10m"

# 替换为的新字符串
new_string="bantime  = 120m"

# 使用 sed 替换文件中的内容
sed -i "s/$old_string/$new_string/g" "$file_path"
systemctl restart fail2ban
echo "fail2ban重启中等待5s"
sleep 5
rm -rf /etc/fail2ban/jail.d/*
echo "开启ssh防御"
cat > /etc/fail2ban/jail.d/sshd.local <<EOF
[sshd]

enabled = true
mode   = normal
backend = systemd
EOF

systemctl restart fail2ban
sleep 5
# 输出完成消息
echo "fail2ban自动化脚本执行完成"
