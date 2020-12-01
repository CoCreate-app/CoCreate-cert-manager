cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cocreate-letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: admin@cocreate.app
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: cocreate-letsencrypt-prod  
    solvers:
    - http01:
        ingress:
          class: nginx
EOF