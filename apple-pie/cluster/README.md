apt install socat -y
socat TCP-LISTEN:80,fork TCP:127.0.0.1:9000
