#!/bin/bash
set -e

mkdir -p /tmp/{lesson-mysql-pv,lesson-wordpress-pv}

echo "=== 1. КЛАСТЕР lesson ==="
kind create cluster --name lesson --config kind-cluster-config.yaml
sleep 180
kubectl get nodes -o wide

echo "=== 2. STORAGE + PV ==="
kubectl apply -f local-storage.yaml
kubectl apply -f pv-mysql.yaml
kubectl apply -f pv-wordpress.yaml
sleep 120
kubectl get sc,pv

echo "=== 3. METRICS-SERVER ==="
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
sleep 60
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
sleep 120
kubectl top nodes

echo "=== 4. NAMESPACE + HELM lesson-wp ==="
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install lesson-wp lesson/ --namespace dev --timeout=10m --wait

echo "=== 5. ВСЕ РЕСУРСЫ 1/1 ==="
kubectl get all,pvc,pv,hpa,networkpolicy,ingress -n dev -o wide
kubectl top pods -n dev

echo "LESSON24 COMPLETE!"
