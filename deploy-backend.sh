#!/bin/bash

# Kointos Amplify Gen 2 Backend Deployment Script

set -e

echo "🚀 Starting Amplify Gen 2 Backend Deployment for Kointos..."

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is required but not installed."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ Error: AWS CLI is required but not installed."
    echo "Please install AWS CLI and configure your credentials."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build and deploy
echo "🏗️ Building and deploying backend..."
echo "Make sure you have configured your AWS credentials using 'aws configure' or 'npx ampx configure profile'"

# Deploy the backend
npx ampx sandbox

echo "✅ Deployment process initiated!"
echo ""
echo "📋 Next steps:"
echo "1. Once deployment is complete, run 'npx ampx generate outputs --format dart --out-dir ./lib' to generate the configuration"
echo "2. Update your Flutter app with the new configuration"
echo "3. Test your authentication and API functionality"
echo ""
echo "🔗 Useful commands:"
echo "- npx ampx sandbox delete    # Delete the sandbox environment"
echo "- npx ampx generate outputs  # Generate configuration files"
echo "- npx ampx console           # Open AWS console for your resources"
