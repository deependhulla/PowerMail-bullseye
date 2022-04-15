echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
ulimit -H -n 50000  1>/dev/null 2>/dev/null
ulimit -S -n 40000  1>/dev/null 2>/dev/null
sysctl -w net.core.netdev_max_backlog=4096  1>/dev/null 2>/dev/null
sysctl -w net.core.somaxconn=4096 1>/dev/null 2>/dev/null
sysctl -w net.ipv4.tcp_max_syn_backlog=4096  1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.all.disable_ipv6=1 1>/dev/null 2>/dev/null
sysctl -w net.ipv6.conf.default.disable_ipv6=1 1>/dev/null 2>/dev/null
