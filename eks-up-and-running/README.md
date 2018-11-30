# Cluster auth and nodes-auth
aws eks update-kubeconfig --name eks-cluster-1 --profile virginia-kubernetes
kubectl craete -f eks-config-auth.yml

#Install Helm
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade

#Metrics Server for HPA
git clone https://github.com/kubernetes-incubator/metrics-server.git
kubectl create -f deploy/1.8+/
