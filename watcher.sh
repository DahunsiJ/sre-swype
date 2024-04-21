#! /bin/bash

# 1. Define Variables: Set The namespace; The deployment name; and The maximum number of allowed restarts before intervention.
NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS=3

# 2. Starting a Loop - This is an infinite loop that will continue until explicitly broken.
while true; do
  # 3. Check Pod Restarts: Fetch the current number of restarts for the first container in the first pod; then match the deployment name in the specified namespace.
    # with kubectl command along with JSONPath expression, extract the restart count.
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  # 4. Print out the current number of restarts.
  echo "$DEPLOYMENT current restarts: $RESTARTS"

  # 5. Check current number of restarts with the predefined maximum allowed.
  if [ $RESTARTS -gt $MAX_RESTARTS ]; then
    # 6. If the restart limit exceeds, log this status and proceed to scale down the deployment
        echo "Exceeded restarts limit. Scaling down $DEPLOYMENT." 
    kubectl scale deployment $DEPLOYMENT --replicas=0 -n $NAMESPACE
    break
  fi
  # 7. If the restart count remains within limits, pause the script for 60 seconds before the next check.
  sleep 60
done

exit 0