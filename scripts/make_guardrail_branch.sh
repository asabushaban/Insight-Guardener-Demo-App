#!/usr/bin/env bash
# Step 6 of the demo: creates a branch that adds a NEW upstream image, so you can open the PR and show the guardrail.
# Run it from the repo root, after the first migration has merged.
set -euo pipefail
BRANCH="demo/add-memcached"
git checkout -b "$BRANCH"
cat > k8s/memcached.yaml << 'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: memcached
spec:
  replicas: 1
  selector:
    matchLabels:
      app: memcached
  template:
    metadata:
      labels:
        app: memcached
    spec:
      containers:
        - name: memcached
          image: memcached:1.6
YAML
git add k8s/memcached.yaml
git commit -m "Add memcached (new upstream image for the guardrail demo)"
git push -u origin "$BRANCH"
echo "Now open a pull request from $BRANCH into your default branch and look for the Guardener review comment."
