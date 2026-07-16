#!/usr/bin/env bash
set -e

CERT_DIR="$(cd "$(dirname "$0")" && pwd)/certs"
DAYS=365

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

MSYS_NO_PATHCONV=1 openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout server.key \
  -out server.crt \
  -days "$DAYS" \
  -subj "/C=RU/ST=Local/L=Local/O=Dev/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

echo "Сертификат создан в $CERT_DIR"
