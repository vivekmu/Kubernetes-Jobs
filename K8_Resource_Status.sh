#!/bin/bash

namespace="myapp"

# Get pod names in the specified namespace and store them in an array
pod_names=($(kubectl get pods -n "$namespace" --no-headers -o custom-columns=":metadata.name"))

# Get pod information for all pods at once and store it in a variable
pod_info=$(kubectl get pod -n "$namespace")

# Get resource usage for all pods at once and store it in a variable
pod_top=$(kubectl top pods -n "$namespace")

# Iterate over the pod names and print pod information from the variables
for pod in "${pod_names[@]}"; do
  echo "$pod_info" | grep "$pod"
  echo "$pod_top" | grep "$pod"
  echo "------------------------"
done

for ns in "${namespace[@]}"; do
  ns_pods_status_resource_limits=$(kubectl get pod -n "$ns" -o jsonpath='{range .items[*]}{.metadata.namespace} {.metadata.name} {.status.phase} {.spec.containers[*].resources.requests.cpu} {.spec.containers[*].resources.requests.memory}{"\n"}{end}')
  #pod_resource_usage=$(kubectl top pods -n "$namespace")
  IFS=$'\n'
  for line in $ns_pods_status_resource_limits; do
    n=$(echo $line | awk -F' +' {'print $1'})
    pod=$(echo $line | awk -F' +' {'print $2'})
    status=$(echo $line | awk -F' +' {'print $3'})
    cpulimit=$(echo $line | awk -F' +' {'print $4'})
    memorylimit=$(echo $line | awk -F' +' {'print $5'})
    echo $n,$pod,$status,$cpulimit,$memorylimit
  done
done
