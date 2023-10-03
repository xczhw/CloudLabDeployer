iptables-save -t nat | grep -- '-A OUTPUT'
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES

# iptables-save -t nat | grep -- '-A KUBE-SERVICES'
...
-A KUBE-SERVICES ! -s 10.244.0.0/16 -d 10.106.224.41/32 -p tcp -m comment --comment "default/kubernetes-bootcamp-v1: cluster IP" -m tcp --dport 8080 -j KUBE-MARK-MASQ
-A KUBE-SERVICES -d 10.106.224.41/32 -p tcp -m comment --comment "default/kubernetes-bootcamp-v1: cluster IP" -m tcp --dport 8080 -j KUBE-SVC-RPP7DHNHMGOIIFDC

# iptables-save -t nat | grep -- '-A KUBE-SVC-RPP7DHNHMGOIIFDC'
-A KUBE-SVC-RPP7DHNHMGOIIFDC -m statistic --mode random --probability 0.33332999982 -j KUBE-SEP-FTIQ6MSD3LWO5HZX
-A KUBE-SVC-RPP7DHNHMGOIIFDC -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-SQBK6CVV7ZCKBTVI
-A KUBE-SVC-RPP7DHNHMGOIIFDC -j KUBE-SEP-IAZPHGLZVO2SWOVD

# iptables-save -t nat | grep -- '-A KUBE-SEP-FTIQ6MSD3LWO5HZX'
...
-A KUBE-SEP-FTIQ6MSD3LWO5HZX -p tcp -m tcp -j DNAT --to-destination 10.244.1.2:8080

192.168.193.172:xxxx -> 10.106.224.41:8080
                      |
                      |  DNAT
                      V
192.168.193.172:xxxX -> 10.244.1.2:8080

# iptables-save -t nat | grep -- '-A POSTROUTING'
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
# iptables-save -t nat | grep -- '-A KUBE-POSTROUTING'
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -m mark --mark 0x4000/0x4000 -j MASQUERADE

192.168.193.172:xxxx -> 10.106.224.41:8080
                      |
                      |  DNAT
                      V
192.168.193.172:xxxx -> 10.244.1.2:8080
                      |
                      |  SNAT
                      V
10.244.0.0:xxxx -> 10.244.1.2:8080

