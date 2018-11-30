 aws-iam-authenticator token -i eks-cluster
 kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &
 http://127.0.0.1:8080/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default
