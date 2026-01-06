#! /bin/bash

# === ПОЛНАЯ ОЧИСТКА ===
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker system prune -a --volumes -f
kind delete cluster --name lesson 2>/dev/null || true
kind get clusters | xargs -I {} kind delete cluster --name {} 2>/dev/null || true

echo "=== 1. КЛАСТЕР ==="
kind create cluster --name lesson --config kind-cluster-config.yaml
sleep 120
kubectl get nodes -o wide

echo "=== 2. PV ПУТИ ==="
docker exec lesson-worker mkdir -p /data/mysql-pv
docker exec lesson-worker2 mkdir -p /data/wordpress-pv

echo "=== 3. METRICS-SERVER ==="
kubectl apply -f 01-metrics-server.yaml
sleep 120
kubectl apply -f 02-metrics-apiservice.yaml
sleep 60

echo "=== 4. WORDPRESS + HPA ==="
kubectl apply -f 03-wordpress-stack.yaml
sleep 180

echo "=== 5. ПРОВЕРКА СТЕКА ==="
kubectl get all,pvc,pv,hpa -n dev
kubectl top pods -n dev
curl -I http://localhost:30080 | head -1

echo "=== 6. NETWORKPOLICY (TASK 1) ==="
kubectl apply -f 04-networkpolicy-mysql.yaml
sleep 120
kubectl get networkpolicy -n dev

echo "=== 7. ДИАГНОСТИКА (TASK 2) ==="
kubectl apply -f 05-diagnostic-pod.yaml
sleep 120
kubectl logs diagnostic-scanner -n diagnostics

echo "=== 8. ТЕСТ NETWORKPOLICY ==="
kubectl run test-client --rm -i --restart=Never --image=busybox -n dev -- \
  sh -c 'wget --spider --timeout=3 mysql:3306 || echo "✓ POLICY BLOCKS!"'

echo "=== 9. ФИНАЛЬНЫЙ СТАТУС ==="
kubectl get all,pvc,pv,hpa -n dev
kubectl top pods -n dev

echo "LESSON23 COMPLETE!"
