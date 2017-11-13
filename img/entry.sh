#!/bin/sh
set -ex
echo "Generating server keys..."
/usr/bin/ssh-keygen -A

echo "Key fingerprint:"
#ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key
echo ""
echo ""

echo "Enabling account 'user'..."
sed -i 's/^user:!/user:*/' /etc/shadow

echo "Setting up tor..."
rm -f /var/log/tor/notices.log
sed -e s/PORT_TO_REPLACE/$TOR_PORT/ /etc/tor/torrc.tpl > /etc/tor/torrc

s6-setuidgid tor tor --runasdaemon 1

echo "Waiting for tor:"
while ! grep -qF '100%: Done' /var/log/tor/notices.log
do
  sleep 1
  echo -n .
done

echo " Done"
echo
echo "Your .onion sshd: $(cat /var/lib/tor/hidden_service/hostname) port $TOR_PORT"

exec "$@"
