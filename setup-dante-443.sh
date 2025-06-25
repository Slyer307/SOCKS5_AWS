#!/bin/bash

echo "🚀 Bắt đầu cài đặt Dante SOCKS5 Proxy (port 443, không xác thực)..."

# 1. Cài Dante
echo "[1/4] Cài dante-server..."
sudo apt update
sudo apt install -y dante-server

# 2. Lấy interface mạng chính
NET_IFACE=$(ip -o -4 route show to default | awk '{print $5}')
PORT=443

# 3. Tạo file cấu hình Dante
echo "[2/4] Tạo file /etc/danted.conf với port $PORT và interface $NET_IFACE..."
sudo tee /etc/danted.conf > /dev/null <<EOF
logoutput: syslog

internal: $NET_IFACE port = $PORT
external: $NET_IFACE

method: none
user.notprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
    method: none
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    log: connect disconnect error
    method: none
}
EOF

# 4. Cấp quyền dùng cổng thấp (<1024)
echo "[3/4] Cấp quyền cho danted sử dụng cổng thấp..."
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/danted || true

# 5. Khởi động và enable dịch vụ
echo "[4/4] Khởi động và kích hoạt danted..."
sudo systemctl enable danted
sudo systemctl restart danted

# ✅ Kiểm tra
echo ""
echo "✅ Cài đặt hoàn tất!"
echo "🌐 IP VPS: $(curl -s ifconfig.me)"
echo "🔌 Port: $PORT (SOCKS5, không xác thực)"
echo "📦 Kiểm tra kết nối bằng: curl --socks5-hostname your_vps_ip:$PORT https://api.ipify.org"
