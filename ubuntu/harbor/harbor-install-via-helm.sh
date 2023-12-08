helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar
helm install my-release .
