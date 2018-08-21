# This file will be removed as per JIRA 844536
# Custom blocking rules as per JIRA AVEN-9297
# Antutu blocked section
iptables -A OUTPUT -d 114.112.93.111 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 114.112.93.113 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 114.112.93.203 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 183.60.153.114 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 123.125.115.123 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 76.73.85.186 -j REJECT --reject-with icmp-net-unreachable
# CoreMark( AndEBench ) blocked section
iptables -A OUTPUT -d 198.154.241.10 -j REJECT --reject-with icmp-net-unreachable
# Geekbench blocked section
iptables -A OUTPUT -d 23.92.21.41 -j REJECT --reject-with icmp-net-unreachable
# Quadrant blocked section
iptables -A OUTPUT -d 74.125.201.121 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 74.125.207.121 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 74.125.137.14 -j REJECT --reject-with icmp-net-unreachable
# results.rightware.com blocked section
iptables -A OUTPUT -d 54.246.109.255 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.77.139.157 -j REJECT --reject-with icmp-net-unreachable
# Vellamo blocked section
iptables -A OUTPUT -d 74.125.201.82 -j REJECT --reject-with icmp-net-unreachable
# Vellamo 3.2
iptables -A OUTPUT -d 199.106.115.68 -j REJECT --reject-with icmp-net-unreachable
# GFXBench blocked section
iptables -A OUTPUT -d 5.159.232.106 -j REJECT --reject-with icmp-net-unreachable
# GFXBench 4.0.2
iptables -A OUTPUT -d 104.40.152.215 -j REJECT --reject-with icmp-net-unreachable
# api.crittercism.com blocked section
iptables -A OUTPUT -d 54.241.32.14 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.241.32.0/24 -j REJECT --reject-with icmp-net-unreachable
# www.flurry.com blocked section
iptables -A OUTPUT -d 216.52.203.53 -j REJECT --reject-with icmp-net-unreachable
# crashstats.mozilla.net blocked section
iptables -A OUTPUT -d 63.245.217.148 -j REJECT --reject-with icmp-net-unreachable
# 3DMark blocked section
iptables -A OUTPUT -d 54.230.192.71 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.239.152.60 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.230.100.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.230.101.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.230.102.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.230.103.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.230.195.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 54.192.101.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 199.106.115.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 216.52.203.0/24 -j REJECT --reject-with icmp-net-unreachable
iptables -A OUTPUT -d 216.137.33.0/24 -j REJECT --reject-with icmp-net-unreachable
