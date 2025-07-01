# 🛰️ Proxy SOCKS5 miễn phí trên AWS cho Telegram (Port 443, không xác thực)

> Dự án giúp bạn triển khai **SOCKS5 proxy** trên **AWS EC2 miễn phí**, tối ưu kết nối từ **Việt Nam**, đặc biệt dùng cho **Telegram**.

---

## ✅ Tính năng

- Cài đặt máy ảo miễn phí AWS (f1-micro hoặc t4g.micro)
- Tự động cài proxy SOCKS5 bằng Dante (cổng 443)
- Không yêu cầu username/password
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

### Cách nhanh nhất:

```bash
curl -O https://raw.githubusercontent.com/Slyer307/free-socks5-telegram-aws/main/setup-dante-443.sh
chmod +x setup-dante-443.sh
./setup-dante-443.sh

**### Chuyển từ cổng 443 sang cổng 1080**

```bash
sudo nano /etc/danted.conf
Thay port 443 thành 1080
sudo systemctl restart danted

