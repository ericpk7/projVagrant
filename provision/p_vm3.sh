sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
