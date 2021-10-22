###Client Authentication Configs
```shell
KUBERNETES_PUBLIC_ADDRESS="100.103.139.254"

for instance in ip-100-103-138-255 ip-100-103-139-8; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done
```
###The kube-proxy Kubernetes Configuration File
```shell
{
  KUBERNETES_PUBLIC_ADDRESS="100.103.139.254"
  
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-proxy.pem \
    --client-key=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}
```
###The kube-controller-manager Kubernetes Configuration File
```shell
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-controller-manager.pem \
    --client-key=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}
```
###The kube-scheduler Kubernetes Configuration File
```shell
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-scheduler.pem \
    --client-key=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}
```
###The admin Kubernetes Configuration File
```shell
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/admin.pem \
    --client-key=/Users/julius.sediolano/workspace/github/kubernetes_cka/cka/2/certs/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
```

```shell
scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    ip-100-103-138-255.kubeconfig \
    kube-proxy.kubeconfig \
    ubuntu@100.103.138.255:~/

scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    ip-100-103-139-8.kubeconfig \
    kube-proxy.kubeconfig \
    ubuntu@100.103.139.8:~/

scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    admin.kubeconfig \
    kube-controller-manager.kubeconfig \
    kube-scheduler.kubeconfig \
    ubuntu@100.103.139.254:~/
```