# 기본 오라클 클라우드 인스턴스 설정
sudo iptables-save > ~/iptables-rules

grep -v "DROP" iptables-rules > tmpfile && mv tmpfile iptables-rules-mod
grep -v "REJECT" iptables-rules-mod > tmpfile && mv tmpfile iptables-rules-mod

sudo iptables-restore < ~/iptables-rules-mod

sudo iptables -L

sudo netfilter-persistent save
sudo systemctl restart iptables

sudo ufw disable

# /etc/hosts에서 아래 추가(프라이빗 IP, 퍼블릭 IP)
# 10.0.14.71		x.x.x.x

# docker 설치

# 기본 설정

# kubeadm install
