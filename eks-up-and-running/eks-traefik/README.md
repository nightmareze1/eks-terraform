# TRAEFIK DEPLOY

# CREATE EBS VOLUME IN AWS AND ADD TAG CLUSTERNAME, ADD VOLUMEID IN TRAEFIK-PV.yml

k create traefik-pv.yml

k create traefik-claim.yml

OR 

# CREATE EFS NETWORK FILESYSTEM

# DEPLOY APP

k create -f acme.yml

k create -f config.yml

cat deploy-template.yml

cat deploy-template-efs.yml

k create -f svc.yml

# DEPLOY EBS OR EFS

k create -f deploy.yml
k craete -f deploy-efs.yml

# ENTER TRAEFIK CONTAINER AND CREATE DIRECTORIO /etc/acme/ and touch acme.yml 0600 , KILL CONTAINER.


# CREATE USER WITH SIMPLE AUTH 
htpasswd -c ./auth zz1
cat auth
kubectl create secret generic mysecret --from-file auth --namespace=kube-system


# CONFIGURE INGRESS WITH AUTH AND SECRET

vi ing-dashboard.yml

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.frontend.rule.type: PathPrefix
    ingress.kubernetes.io/auth-type: "basic"
    ingress.kubernetes.io/auth-secret: "mysecret"
  generation: 1
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  rules:
  - host: app5.itshellweb.org
    http:
      paths:
      - backend:
          serviceName: kubernetes-dashboard
          servicePort: 443
        path: /

k create -f ing-dashboard.yml

# URL
kubectl create serviceaccount --namespace kube-system traefik-ingress-controller
kubectl create clusterrolebinding traefik-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:traefik-ingress-controller
