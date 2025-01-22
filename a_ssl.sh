#!/bin/bash

# Variables
ROOT_CA_KEY="rootCA.key"
ROOT_CA_CERT="rootCA.pem"
SERVER_KEY="server.key"
SERVER_CSR="server.csr"
SERVER_CERT="server.crt"
CA_SERIAL="rootCA.srl"
SAN_CONFIG="san.cnf"
DAYS_VALID=365

DOMAIN="example.com"  # Replace with your domain
ALT_NAMES=("example.com" "www.example.com" "192.168.1.1")  # Replace with your SANs

# Step 1: Create Root CA
echo "[INFO] Generating Root CA..."
openssl genrsa -out $ROOT_CA_KEY 2048
openssl req -x509 -new -nodes -key $ROOT_CA_KEY -sha256 -days $((DAYS_VALID * 10)) -out $ROOT_CA_CERT -subj "/C=US/ST=State/L=City/O=Organization/CN=RootCA"

# Step 2: Generate Server Private Key
echo "[INFO] Generating Server Private Key..."
openssl genrsa -out $SERVER_KEY 2048

# Step 3: Create SAN Configuration
echo "[INFO] Creating SAN configuration file..."
cat > $SAN_CONFIG <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = $DOMAIN

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
EOF

# Add SANs to the config
i=1
for name in "${ALT_NAMES[@]}"; do
    echo "DNS.${i} = ${name}" >> $SAN_CONFIG
    i=$((i + 1))
done

# Step 4: Generate CSR
echo "[INFO] Generating Certificate Signing Request (CSR)..."
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -config $SAN_CONFIG

# Step 5: Sign the CSR with the Root CA
echo "[INFO] Signing the CSR with the Root CA to create Server Certificate..."
openssl x509 -req -in $SERVER_CSR -CA $ROOT_CA_CERT -CAkey $ROOT_CA_KEY -CAcreateserial -out $SERVER_CERT -days $DAYS_VALID -sha256 -extensions v3_req -extfile $SAN_CONFIG

# Step 6: Cleanup
rm -f $SAN_CONFIG $CA_SERIAL

# Step 7: Display Output
echo "[INFO] SSL Certificate and keys generated successfully."
echo "Files:"
echo "  Root CA Key: $ROOT_CA_KEY"
echo "  Root CA Certificate: $ROOT_CA_CERT"
echo "  Server Key: $SERVER_KEY"
echo "  Server Certificate: $SERVER_CERT"
echo
echo "[INFO] To trust this certificate, install '$ROOT_CA_CERT' in your OS or browser."
