###The kubelet Kubernetes Configuration File
```shell
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/home/ubuntu/ca.pem \
    --embed-certs=true \
    --server=https://100.103.139.205:6443 \
    --kubeconfig=ip-100-103-138-196.kubeconfig
    
kubectl config set-credentials system:node:ip-100-103-138-196 \
    --client-certificate=/home/ubuntu/ip-100-103-138-196.pem \
    --client-key=/home/ubuntu/ip-100-103-138-196-key.pem \
    --embed-certs=true \
    --kubeconfig=ip-100-103-138-196.kubeconfig
    
kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:ip-100-103-138-196 \
    --kubeconfig=ip-100-103-138-196.kubeconfig

kubectl config use-context default --kubeconfig=ip-100-103-138-196.kubeconfig
```

###The kube-proxy Kubernetes Configuration File
```shell
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/home/ubuntu/ca.pem \
    --embed-certs=true \
    --server=https://100.103.139.205:6443 \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
    --client-certificate=/home/ubuntu/kube-proxy.pem \
    --client-key=/home/ubuntu/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
```

###The kube-controller-manager Kubernetes Configuration File
```shell
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
```