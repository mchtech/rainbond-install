DEFAULT_IPV4={{ grains.fqdn_ip4|first }}
ETCD_ENDPOINTS=http://172.16.0.172:2379
NODE_IMAGE={{ pillar.network.calico.get('image', 'rainbond/calico-node:v2.4.1') }}