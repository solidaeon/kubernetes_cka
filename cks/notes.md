### Generate CA
```
// Generate the private key
openssl genrsa -out ca.key 2048

// Create the CSR
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr

// Self sign the CSR
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000
```
---

## ETCD
### Create certificate for ETCD
```
// Generate the private key
openssl genrsa -out etcd.key 2048

// Create the CSR
cat > etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 [host_ip]
IP.2 127.0.0.1
EOF

// Generate the CSR
openssl req -new -key etcd.key -subj "/CN=etcd" -out ca.csr -config etcd.cnf

// Self sign the CSR
openssl x509 -req -in etcd.csr -signkey ca.key -CAcreateserial -out etcd.crt -extensions v3_req -extfile etcd.cnf -days 1000
```
### Run ETCD
```
etcd \
--cert-file /path/to/ectd.crt \
--key-file /path/to/etcd.key \
--advertise-client-url ip_or_dns_of_etcd \
--listen-client-urls ip_or_dns_of_etcd
```
---
## KUBEAPI SERVER
### Generate CLIENT cert
```
// Generate the private key
openssl genrsa -out apiserver.key 2048

// Create the CSR
openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" -out apiserver.csr

// Self sign the CSR
openssl x509 -req -in apiserver.csr -signkey ca.key -CAcreateserial -out apiserver.crt -days 1000
```
### Generate Encryption Provider
```
// Generate encryption key
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

// Create the encryption config
cat > encrypt-at-rest.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
```