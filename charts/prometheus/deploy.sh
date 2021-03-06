#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ../../scripts/helm-functions.sh

helm_chart='./chart/prometheus'
helm_chart_version='8.9.0'
helm_release='prometheus'
helm_namespace='kubetools'
helm_values_filepath='values.yaml'

kubectl create secret generic prometheus-basicauth --namespace=$helm_namespace --from-file=auth --dry-run -o yaml | kubectl apply -f -
kubectl apply -f ./manifests --namespace=$helm_namespace

helm_dryrun $helm_chart $helm_chart_version $helm_release $helm_namespace $helm_values_filepath

helm_deploy_recreate_pods $helm_chart $helm_chart_version $helm_release $helm_namespace $helm_values_filepath

helm_check_all_pods_successful $helm_release


