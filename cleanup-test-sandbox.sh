#!/bin/bash

# AWS Amplify Sandbox Cleanup Script
# This script cleans up the test sandbox environment

set -e

echo "🧹 Cleaning up AWS Amplify Sandbox..."

cd amplify

# Check if sandbox PID file exists
if [ -f "sandbox.pid" ]; then
    SANDBOX_PID=$(cat sandbox.pid)
    echo "🔍 Found sandbox PID: $SANDBOX_PID"
    
    # Check if process is still running
    if ps -p $SANDBOX_PID > /dev/null; then
        echo "🛑 Stopping sandbox process..."
        kill $SANDBOX_PID
        sleep 5
    fi
    
    # Remove PID file
    rm sandbox.pid
    echo "✅ Removed sandbox PID file"
fi

# Clean up sandbox resources
echo "🗑️  Deleting sandbox resources..."
npx ampx sandbox delete --yes || echo "⚠️  No sandbox to delete or delete failed"

echo "✅ Sandbox cleanup completed"
echo "💡 All temporary AWS resources have been removed"
