#!/bin/bash

echo "🚀 Bắt đầu cài đặt Dante SOCKS5 Proxy (port 443, có xác thực username/password)..."

# 1. Cài Dante
echo "[1/5] Cài dante-server..."
sudo apt update
sudo apt install -y dante-server

# 2. Tạo user để xác thực
USERNAME="proxyuser"
PASSWORD="telegram123"

echo "[2/5] Tạo user '$USERNAME' để xác thực SOCKS5..."
sudo adduser --disabled-password --gecos "" $USERNAME
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# 3. Xác định interface mạng
NET_IFACE=$(ip -o -4 route show to default | awk '{print $5}')
PORT=443

# 4. Tạo file cấu hình Dante
echo "[3/5] Tạo file /etc/danted.conf với port $PORT và interface $NET_IFACE..."
sudo tee /etc/danted.conf > /dev/null <<EOF
logoutput: syslog

internal: $NET_IFACE port = $PORT
external: $NET_IFACE

method: username none
user.notprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: connect bind
    log: connect disconnect error
    method: username
}
EOF

# 5. Cấp quyền cổng thấp + khởi động dịch vụ
echo "[4/5] Cấp quyền cho danted sử dụng cổng thấp..."
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/danted || true

echo "[5/5] Khởi động và kích hoạt danted..."
sudo systemctl enable danted
sudo systemctl restart danted

# ✅ Hoàn tất
echo ""
echo "✅ Cài đặt hoàn tất!"
echo "🌐 IP VPS: $(curl -s ifconfig.me)"
echo "🔌 Port: $PORT (SOCKS5, xác thực bằng username/password)"
echo "👤 Username: $USERNAME"
echo "🔒 Password: $PASSWORD"
echo ""
echo "📦 Kiểm tra kết nối bằng:"
echo "curl -x socks5h://$USERNAME:$PASSWORD@your_vps_ip:$PORT https://api.ipify.org"
