![GitHub file size in bytes](https://img.shields.io/github/size/CoCreate-app/CoCreate-boilerplate/dist/CoCreate-boilerplate.min.js?label=minified%20size) 
![GitHub package.json version](https://img.shields.io/github/package-json/v/CoCreate-app/CoCreate-boilerplate)
![GitHub](https://img.shields.io/github/license/CoCreate-app/CoCreate-boilerplate) 
![GitHub labels](https://img.shields.io/github/labels/CoCreate-app/CoCreate-boilerplate/help%20wanted)

# CoCreate-cert-manager
A cert

![CoCreate](https://cdn.cocreate.app/logo.png)


While writting this doc the cert-manager version is 1.1.0: 


- ### Installing cert manager.

```

$ kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml


*or*

$ kubectl apply -f manifests/cert-manager.yaml
```


- ### Check if properly deployed:

```
$ kubectl get pods --namespace cert-manager


> ~/bharat/github/clones> kubectl get pods --namespace cert-manager
NAME                                      READY   STATUS    RESTARTS   AGE
cert-manager-5597cff495-z5kdb             1/1     Running   0          109m
cert-manager-cainjector-bd5f9c764-z48q8   1/1     Running   0          109m
cert-manager-webhook-5f57f59fbc-nntvf     1/1     Running   0          109m
```


- ### Create a certificate ClusterIssuer object. 

> If you want namespace specific then create Issuer instead of ClusterIssuer object.

```
$ kubectl apply -f manifests/cocreate_prod_issuer.yml

clusterissuer.cert-manager.io/cocreate-letsencrypt-prod created

```

- ### Describe the cluster issuer

```
$ kubectl describe clusterissuer cocreate-letsencrypt-prod
```

- ### Modify ingress accordingly:

    - Add ingress anotation:
        ```
        cert-manager.io/cluster-issuer: "cocreate-letsencrypt-prod"
        ```

    - Add tls in ingress spec
        ```
        tls:
        - hosts:
        - ws.cocreate.app
        secretName: ws-tls-secret
        ```

- ### Basic Info gathering

```

> ~/bharat/github/clones> kubectl get clusterissuer
NAME                        READY   AGE
cocreate-letsencrypt-prod   True    43m

> ~/bharat/github/clones> kubectl describe clusterissuer cocreate-letsencrypt-prod
Name:         cocreate-letsencrypt-prod
Namespace:
Labels:       <none>
Annotations:  API Version:  cert-manager.io/v1
Kind:         ClusterIssuer
Metadata:
  Creation Timestamp:  2020-12-01T20:48:55Z
  Generation:          2
  Managed Fields:
    API Version:  cert-manager.io/v1
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .:
          f:kubectl.kubernetes.io/last-applied-configuration:
      f:spec:
        .:
        f:acme:
          f:email:
          f:privateKeySecretRef:
            .:
            f:name:
          f:solvers:
    Manager:      kubectl
    Operation:    Update
    Time:         2020-12-01T21:34:42Z
    API Version:  cert-manager.io/v1
    Fields Type:  FieldsV1
    fieldsV1:
      f:status:
        .:
        f:acme:
          .:
          f:lastRegisteredEmail:
          f:uri:
        f:conditions:
    Manager:         controller
    Operation:       Update
    Time:            2020-12-01T21:34:43Z
  Resource Version:  1888290
  Self Link:         /apis/cert-manager.io/v1/clusterissuers/cocreate-letsencrypt-prod
  UID:               0dd09703-7fb0-43c8-b6f5-8bf8531509ee
Spec:
  Acme:
    Email:            admin@cocreate.app
    Preferred Chain:
    Private Key Secret Ref:
      Name:  cocreate-letsencrypt-prod
    Server:  https://acme-v02.api.letsencrypt.org/directory
    Solvers:
      http01:
        Ingress:
          Class:  nginx
Status:
  Acme:
    Last Registered Email:  admin@cocreate.app
    Uri:                    https://acme-v02.api.letsencrypt.org/acme/acct/104676621
  Conditions:
    Last Transition Time:  2020-12-01T20:48:55Z
    Message:               The ACME account was registered with the ACME server
    Reason:                ACMEAccountRegistered
    Status:                True
    Type:                  Ready
Events:                    <none>

```

- Getting  ingress,certificate,secret info

```
> ~/bharat/github/clones> kubectl describe ingress cocreate-ws-ingress
Name:             cocreate-ws-ingress
Namespace:        default
Address:          18.206.219.104,34.207.216.116
Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
TLS:
  ws-tls-secret terminates ws.cocreate.app
Rules:
  Host             Path  Backends
  ----             ----  --------
  ws.cocreate.app
                   /   cocreate-ws-service:8081 (10.42.1.30:8081)
Annotations:       cert-manager.io/cluster-issuer: cocreate-letsencrypt-prod
                   field.cattle.io/publicEndpoints:
                     [{"addresses":["18.206.219.104"],"port":443,"protocol":"HTTPS","serviceName":"default:cocreate-ws-service","ingressName":"default:cocreate...
                   meta.helm.sh/release-name: cocreatews-manifests
                   meta.helm.sh/release-namespace: default
                   objectset.rio.cattle.io/id: default-cocreatews-manifests
Events:
  Type    Reason             Age                   From                      Message
  ----    ------             ----                  ----                      -------
  Normal  UPDATE             2m45s (x7 over 3d1h)  nginx-ingress-controller  Ingress default/cocreate-ws-ingress
  Normal  UPDATE             2m45s (x7 over 3d1h)  nginx-ingress-controller  Ingress default/cocreate-ws-ingress
  Normal  CreateCertificate  2m45s                 cert-manager              Successfully created Certificate "ws-tls-secret"



> ~/bharat/github/clones> kubectl describe certificate ws-tls-secret
Name:         ws-tls-secret
Namespace:    default
Labels:       app.kubernetes.io/managed-by=Helm
              objectset.rio.cattle.io/hash=9b7b409fc93ef02c6b701fa15758f4cb05e1a034
Annotations:  <none>
API Version:  cert-manager.io/v1
Kind:         Certificate
Metadata:
  Creation Timestamp:  2020-12-01T22:02:36Z
  Generation:          1
  Managed Fields:
    API Version:  cert-manager.io/v1
    Fields Type:  FieldsV1
    fieldsV1:
      f:metadata:
        f:labels:
          .:
          f:app.kubernetes.io/managed-by:
          f:objectset.rio.cattle.io/hash:
        f:ownerReferences:
          .:
          k:{"uid":"b6af7fbc-99c8-4c5b-8116-2144569e0286"}:
            .:
            f:apiVersion:
            f:blockOwnerDeletion:
            f:controller:
            f:kind:
            f:name:
            f:uid:
      f:spec:
        .:
        f:dnsNames:
        f:issuerRef:
          .:
          f:group:
          f:kind:
          f:name:
        f:secretName:
      f:status:
        .:
        f:conditions:
        f:notAfter:
        f:notBefore:
        f:renewalTime:
        f:revision:
    Manager:    controller
    Operation:  Update
    Time:       2020-12-01T22:03:01Z
  Owner References:
    API Version:           extensions/v1beta1
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  Ingress
    Name:                  cocreate-ws-ingress
    UID:                   b6af7fbc-99c8-4c5b-8116-2144569e0286
  Resource Version:        1895360
  Self Link:               /apis/cert-manager.io/v1/namespaces/default/certificates/ws-tls-secret
  UID:                     92dcc22f-c048-4be9-9592-cd1ee2098ddc
Spec:
  Dns Names:
    ws.cocreate.app
  Issuer Ref:
    Group:      cert-manager.io
    Kind:       ClusterIssuer
    Name:       cocreate-letsencrypt-prod
  Secret Name:  ws-tls-secret
Status:
  Conditions:
    Last Transition Time:  2020-12-01T22:03:01Z
    Message:               Certificate is up to date and has not expired
    Reason:                Ready
    Status:                True
    Type:                  Ready
  Not After:               2021-03-01T21:03:01Z
  Not Before:              2020-12-01T21:03:01Z
  Renewal Time:            2021-01-30T21:03:01Z
  Revision:                1
Events:
  Type    Reason     Age    From          Message
  ----    ------     ----   ----          -------
  Normal  Issuing    3m2s   cert-manager  Issuing certificate as Secret does not exist
  Normal  Generated  3m2s   cert-manager  Stored new private key in temporary Secret resource "ws-tls-secret-hbnqb"
  Normal  Requested  3m2s   cert-manager  Created new CertificateRequest resource "ws-tls-secret-4vpcw"
  Normal  Issuing    2m38s  cert-manager  The certificate has been successfully issued



> ~/bharat/github/clones> kubectl describe secret ws-tls-secret
Name:         ws-tls-secret
Namespace:    default
Labels:       <none>
Annotations:  cert-manager.io/alt-names: ws.cocreate.app
              cert-manager.io/certificate-name: ws-tls-secret
              cert-manager.io/common-name: ws.cocreate.app
              cert-manager.io/ip-sans:
              cert-manager.io/issuer-group: cert-manager.io
              cert-manager.io/issuer-kind: ClusterIssuer
              cert-manager.io/issuer-name: cocreate-letsencrypt-prod
              cert-manager.io/uri-sans:

Type:  kubernetes.io/tls

Data
====
tls.key:  1675 bytes
tls.crt:  3558 bytes

```