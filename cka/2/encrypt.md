```shell
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml <<EOF
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

scp -i ~/workspace/pem/jp-devops-asurion-poc-apne1-keypair.pem \
    encryption-config.yaml \
    ubuntu@100.103.139.254:~/
```