#!/bin/bash

# AWS Amplify Sandbox Setup for Testing
# This script sets up a development/testing environment using AWS Amplify sandboxes

set -e

echo "🧪 Setting up AWS Amplify Sandbox for Kointos Testing..."

# Check if npx is available
if ! command -v npx &> /dev/null; then
    echo "❌ Error: npx is required but not installed."
    echo "Please install Node.js which includes npx."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Error: AWS CLI is not configured or credentials are invalid."
    echo "Please run 'aws configure' to set up your credentials."
    exit 1
fi

# Create a sandbox environment
echo "🏗️  Creating Amplify Gen 2 sandbox environment..."

cd amplify

# Install dependencies
echo "📦 Installing Amplify dependencies..."
npm install

# Start sandbox
echo "🚀 Starting Amplify sandbox..."
echo "This will create a temporary AWS environment for testing."
echo "The sandbox will be deleted when you stop it."

# Run in background so we can continue with setup
npx ampx sandbox --once &
SANDBOX_PID=$!

echo "⏳ Waiting for sandbox to initialize..."
sleep 30

# Check if sandbox is running
if ps -p $SANDBOX_PID > /dev/null; then
    echo "✅ Sandbox is running with PID: $SANDBOX_PID"
    echo "📋 Sandbox resources are being created..."
    echo ""
    echo "To monitor the sandbox:"
    echo "  - Check the AWS Console for resources"
    echo "  - View logs with: npx ampx sandbox --outputs"
    echo ""
    echo "To stop the sandbox:"
    echo "  - Run: kill $SANDBOX_PID"
    echo "  - Or: npx ampx sandbox delete"
    echo ""
    echo "🧪 You can now run Flutter tests against the sandbox environment"
    echo "Run: cd .. && flutter test"
else
    echo "❌ Failed to start sandbox"
    exit 1
fi

# Save PID for cleanup
echo $SANDBOX_PID > sandbox.pid
echo "💾 Sandbox PID saved to sandbox.pid"
