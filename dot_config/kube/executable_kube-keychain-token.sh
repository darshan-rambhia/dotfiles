#!/bin/bash
# kubectl exec credential plugin — fetches bearer token from macOS Keychain
# Usage: kube-keychain-token.sh <keychain-service-name>
# e.g.  kube-keychain-token.sh kube-token-dev

SERVICE="$1"
if [ -z "$SERVICE" ]; then
  echo "Usage: $0 <keychain-service-name>" >&2
  exit 1
fi

TOKEN=$(security find-generic-password -s "$SERVICE" -w 2>/dev/null)
if [ -z "$TOKEN" ]; then
  echo "Failed to retrieve token for service: $SERVICE" >&2
  exit 1
fi

cat <<EOF
{
  "apiVersion": "client.authentication.k8s.io/v1",
  "kind": "ExecCredential",
  "status": {
    "token": "$TOKEN"
  }
}
EOF
