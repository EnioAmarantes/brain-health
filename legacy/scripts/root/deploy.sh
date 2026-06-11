#!/bin/bash

# Complete deployment script for both frontend and backend
set -e

PROJECT_ROOT=$(dirname "$0")
VPS_IP="191.252.223.30"
VPS_USER="root"

echo "========================================"
echo "Brain Health - Complete Deployment"
echo "========================================"

# Get deployment type
if [ "$1" == "frontend" ]; then
    DEPLOY_TYPE="frontend"
elif [ "$1" == "backend" ]; then
    DEPLOY_TYPE="backend"
else
    DEPLOY_TYPE="both"
fi

# Frontend deployment
if [ "$DEPLOY_TYPE" == "frontend" ] || [ "$DEPLOY_TYPE" == "both" ]; then
    echo ""
    echo ">>> DEPLOYING FRONTEND"
    bash "$PROJECT_ROOT/deploy-frontend.sh"
fi

# Backend deployment
if [ "$DEPLOY_TYPE" == "backend" ] || [ "$DEPLOY_TYPE" == "both" ]; then
    echo ""
    echo ">>> DEPLOYING BACKEND"
    bash "$PROJECT_ROOT/deploy-backend.sh"
fi

echo ""
echo "========================================"
echo "✓ Deployment Complete!"
echo "========================================"
echo "Frontend: https://meunegociosimples.net"
echo "API:      https://meunegociosimples.net/api/health"
echo ""
echo "Usage: ./deploy.sh [frontend|backend|both]"
