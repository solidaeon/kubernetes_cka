### CA Cert
```shell
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

```
###The Admin Client Certificate
```shell
cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin
  
```
###The Kubelet Client Certificates
```shell
for instance in ip-100-103-138-255 ip-100-103-139-8; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

EXTERNAL_IP="100.103.139.254"
INTERNAL_IP="100.103.139.254"

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
```
###The Controller Manager Client Certificate
```shell
cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
```
###The Kube Proxy Client Certificate
```shell
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy
```
###The Scheduler Client Certificate
```shell
cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler
```
###The Kubernetes API Server Certificate
```shell
KUBERNETES_PUBLIC_ADDRESS="100.103.139.254"

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Nashville",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Tennessee"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
```
###The Service Account Key Pair
```shell
cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account
```
###Distribute the Client and Server Certificates
```shell
scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    ip-100-103-138-255-key.pem \
    ip-100-103-138-255.pem \
    ubuntu@100.103.138.255:~/

scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    ip-100-103-139-8-key.pem \
    ip-100-103-139-8.pem \
    ubuntu@100.103.139.8:~/

scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    ca-key.pem \
    kubernetes-key.pem \
    kubernetes.pem \
    service-account-key.pem \
    service-account.pem \
    ubuntu@100.103.139.254:~/
```
