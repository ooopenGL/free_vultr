#!/usr/bin
sudo yum install -y expect
sudo yum install -y m2crypto python-setuptools
sudo easy_install pip
sudo pip install shadowsocks

# 配置ss文件
file='/etc/shadowsocks.json'
if [ ! -f "$file" ]; then
 touch "$file"
fi
ip=`curl icanhazip.com`
psd=''
port=
echo '{' > /etc/shadowsocks.json
echo "	\"server\":\"${ip}\"," >> /etc/shadowsocks.json
echo "	\"server_port\":$port," >> /etc/shadowsocks.json
echo "	\"password\":\"${psd}\"," >> /etc/shadowsocks.json
echo "	\"timeout\":300," >> /etc/shadowsocks.json
echo "	\"method\":\"aes-256-cfb\",">> /etc/shadowsocks.json
echo "	\"fast_open\":false" >> /etc/shadowsocks.json
echo '}' >> /etc/shadowsocks.json

echo "ssserver -c /etc/shadowsocks.json -d start" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
# 配置防火墙
firewall-cmd --permanent --add-port=$port/tcp

# 安装bbr
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod +x bbr.sh
/usr/bin/expect <<-EOF
set timeout 40
spawn ./bbr.sh
expect "*start..."
send "y \r"
expect "restart"
send "n \r"
expect eof
EOF

reboot
