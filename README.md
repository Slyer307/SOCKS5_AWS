# 🛰️ Proxy SOCKS5 trên AWS cho Telegram

> Dự án giúp bạn triển khai **SOCKS5 proxy** trên **AWS EC2 miễn phí**, tối ưu kết nối từ **Việt Nam**, đặc biệt dùng cho **Telegram**.

---

## ✅ Tính năng

- Cài đặt máy ảo miễn phí AWS (f1-micro hoặc t4g.micro)
- Tự động cài proxy SOCKS5 bằng Dante (cổng 443)
- Bảo vệ bằng **username/password** mặc định: `proxyuser` / `telegram123`
- Tự động khởi động khi reboot VPS
- Tối ưu mạng cho kết nối ổn định và ping thấp từ Việt Nam

---

## 🚀 Bắt đầu

### 1. Tạo VPS miễn phí trên AWS

- Sử dụng loại máy:
  - `t4g.micro` (ARM) — miễn phí 750h/tháng (nếu chọn Amazon Linux 2023)
  - `t2.micro` hoặc `f1-micro` (x86) — nếu có trong gói Free Tier
- Khu vực đề xuất:
  - `ap-southeast-1` (Singapore)
  - `ap-northeast-1` (Tokyo)
  - `ap-east-1` (Hong Kong)
- Hệ điều hành đề xuất: **Ubuntu 22.04**

### 2. Mở port 443 trong Security Group của EC2

- Inbound Rule:
  - Type: Custom TCP
  - Port: `443`
  - Source: `0.0.0.0/0` (hoặc IP bạn)

---

## ⚙️ Cài đặt SOCKS5 Proxy

### (1) **Cách nhanh nhất**

```bash
curl -O https://raw.githubusercontent.com/Slyer307/free-socks5-telegram-aws/main/setup-dante-443.sh
chmod +x setup-dante-443.sh
./setup-dante-443.sh
```

---

### 🔐 Thông tin đăng nhập SOCKS5

- Server: `your_vps_ip`
- Port: `443`
- Username: `proxyuser`
- Password: `telegram123`

---

### 🔐 Thay đổi thông tin đăng nhập mặc định

**(1) Dừng dịch vụ**

```bash
sudo systemctl stop danted
```

**(2) Đổi tên truy cập, ví dụ đổi từ proxyuser thành tgproxy**

```bash
sudo usermod -l tgproxy proxyuser
```

**(3) Đổi mật khẩu**

```bash
sudo passwd tgproxy
```

**(4) Khởi động lại dịch vụ:**

```bash
sudo systemctl start danted
```

---

### 🧪 Kiểm tra kết nối từ máy client

```bash
curl -x socks5h://proxyuser:telegram123@your_vps_ip:443 https://api.ipify.org
```

> Lệnh trên sẽ in ra IP của VPS nếu proxy hoạt động bình thường.
