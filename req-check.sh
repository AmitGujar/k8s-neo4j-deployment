#!/bin/bash

requirement_check() {
    if ! command -v kubectl &>/dev/null; then
        return 1
    fi

    if ! command -v helm &>/dev/null; then
        return 1
    fi

    kubectl get no &>/dev/null

    if [ $? -ne 0 ]; then
        return 1
    fi

    return 0
}

requirement_check

blog_url="https://amitgujar15.medium.com/deploy-neo4j-on-aks-with-tls-and-reverse-proxy-39b003e74ac2"

if [ $? -ne 0 ]; then
    echo "Read the blog carefully..."
    redirect=$(xdg-open "$blog_url" &>/dev/null || echo "bye")
    echo "$redirect"
    exit 1
else
    echo "You are doing great...!!!"
fi