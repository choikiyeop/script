# https://argo-cd.readthedocs.io/en/stable/getting_started/

echo "Install Argo CD"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# kubectl port-forward svc/argocd-server -n argocd 8080:443
