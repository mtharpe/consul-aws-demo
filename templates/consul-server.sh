#!/bin/bash

export IP_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

apt-get update
# Install unzip and dnsmasq
apt-get install -y unzip dnsmasq

## Setup consul
mkdir -p /var/lib/consul
mkdir -p /etc/consul.d

curl \
  --silent \
  --location \
  --output consul.zip \
  https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul.zip
mv consul /usr/local/bin/consul
rm consul.zip

# Register web service
sudo tee /etc/consul.d/server.hcl > /dev/null <<"EOF"
connect {
  enabled = true
}
EOF

cat > consul.service <<'EOF'
[Unit]
Description=consul
Documentation=https://consul.io/docs/

[Service]
Environment=CONSUL_UI_BETA=true
ExecStart=/usr/local/bin/consul agent \
  -advertise=ADVERTISE_ADDR \
  -datacenter=${datacenter} \
  -bind=0.0.0.0 \
  -bootstrap-expect ${consul_server_count} \
  -retry-join "provider=aws tag_key=${retry_join_tag} tag_value=${retry_join_tag}" \
  -client=0.0.0.0 \
  -data-dir=/var/lib/consul \
  -config-dir=/etc/consul.d \
  -server \
  -ui

ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sed -i "s/ADVERTISE_ADDR/$IP_ADDRESS/" consul.service
mv consul.service /etc/systemd/system/consul.service
systemctl enable consul
systemctl start consul

# Configure dnsmasq
mkdir -p /etc/dnsmasq.d
cat > /etc/dnsmasq.d/10-consul <<'EOF'
server=/consul/127.0.0.1#8600
EOF

systemctl enable dnsmasq
systemctl start dnsmasq
# Force restart for adding consul dns
systemctl restart dnsmasq

