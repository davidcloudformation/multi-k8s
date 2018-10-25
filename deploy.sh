#!/usr/bin/env bash
docker build -t thdavidtan/multi-client:latest -t thdavidtan/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t thdavidtan/multi-server:latest -t thdavidtan/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t thdavidtan/multi-worker:latest -t thdavidtan/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push thdavidtan/multi-client:latest
docker push thdavidtan/multi-server:latest
docker push thdavidtan/multi-worker:latest

docker push thdavidtan/multi-client:$SHA
docker push thdavidtan/multi-server:$SHA
docker push thdavidtan/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=thdavidtan/multi-server:$SHA
kubectl set image deployments/client-deployment client=thdavidtan/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=thdavidtan/multi-worker:$SHA