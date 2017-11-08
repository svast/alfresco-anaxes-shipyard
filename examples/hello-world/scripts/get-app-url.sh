#!/bin/bash

if [ $# -lt 1 ] ; then 
  echo "usage: get-app-url.sh <release-name> [namespace]"
  exit 1
fi

RELEASE=$1-hello-world-app-ui

if [ $# == 2 ] ; then 
  NAMESPACE="--namespace $2"
else
  NAMESPACE=""
fi

CONTEXT=$(kubectl config current-context)

if [[ $CONTEXT == "minikube" ]] ; then
    IP=$(minikube ip)
    PATH=$(kubectl get ingresses $RELEASE-ingress $NAMESPACE -o jsonpath={.spec.rules[0].http.paths[0].path})
    echo "http://$IP$PATH"
else
    URL=$(kubectl get services $RELEASE $NAMESPACE -o jsonpath={.status.loadBalancer.ingress[0].hostname})
    echo "http://$URL"
fi