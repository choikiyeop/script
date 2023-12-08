# https://argo-cd.readthedocs.io/en/stable/getting_started/

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Download Argo CD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Expose external IP
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Login Using The CLI
echo "show initial password!"
argocd admin initial-password -n argocd
