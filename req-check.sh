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

if [ $? -ne 0 ]; then
    echo "Read the blog carefully..."
    redirect=$(xdg-open "url will be updated after publishing the blog" &>/dev/null || echo "bye")
    echo "$redirect"
    exit 1
else
    echo "You are doing great...!!!"
fi