### Create CA Cert

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
```

```shell
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
```

```shell
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
```

### Create admin cert

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

### The Kubelet Client Certificates

```shell
cat > ip-100-103-138-196-csr.json <<EOF
{
  "CN": "system:node:ip-100-103-138-196",
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

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=ip-100-103-138-196,100.103.138.196 \
  -profile=kubernetes \
  ip-100-103-138-196-csr.json | cfssljson -bare ip-100-103-138-196
```

### The Controller Manager Client Certificate
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

### The Kube Proxy Client Certificate
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

### The Scheduler Client Certificate
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

### The Kubernetes API Server Certificate
```shell
KUBERNETES_PUBLIC_ADDRESS="100.103.139.205"

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

### The Service Account Key Pair
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
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account
```

### Copy worker certs
```shell
scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem ./ca.pem ubuntu@100.103.138.196:/home/ubuntu/ca.pem
scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem ./ip-100-103-138-196-key.pem ubuntu@100.103.138.196:/home/ubuntu/ip-100-103-138-196-key.pem
```

### Copy controlplane certs
```shell
scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem ./ca.pem ./ca-key.pem ./kubernetes-key.pem ./kubernetes.pem ./service-account-key.pem ./service-account.pem ubuntu@100.103.139.205:~/
```