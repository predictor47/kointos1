# 🔧 Bedrock Bot Troubleshooting Guide

## Current Issue
The bot is showing dummy data replies because it cannot connect to AWS Bedrock. The error `getaddrinfo ENOTFOUND bedrock-runtime.us-east-1.amazonaws.com` indicates a DNS/network issue.

## Quick Diagnosis Steps

### 1. Test Bedrock Connection
1. Open the app and navigate to **Settings → Developer Tools**
2. Click **"Test Bedrock Connection"** button
3. Check the result message for specific errors

### 2. Common Issues & Solutions

#### ❌ DNS/Network Error: `ENOTFOUND bedrock-runtime.us-east-1.amazonaws.com`
**Causes:**
- Network connectivity issues
- DNS resolution problems
- Firewall blocking AWS endpoints
- VPN interference

**Solutions:**
1. Check your internet connection
2. Try disabling VPN if using one
3. Flush DNS cache:
   - Windows: `ipconfig /flushdns`
   - Mac: `sudo dscacheutil -flushcache`
4. Test AWS connectivity: `nslookup bedrock-runtime.us-east-1.amazonaws.com`

#### ❌ Authentication Error: "Failed to get AWS credentials"
**Causes:**
- User not logged in
- Amplify backend not deployed
- IAM permissions not configured

**Solutions:**
1. Ensure you're logged into the app
2. Deploy Amplify backend: `npx ampx sandbox` or `npx ampx push`
3. Verify IAM role has Bedrock permissions

#### ❌ Access Denied Error
**Causes:**
- Claude 3 Haiku not enabled in AWS Bedrock
- Wrong AWS region
- IAM permissions missing

**Solutions:**
1. Go to AWS Bedrock Console → Model access
2. Enable "Claude 3 Haiku" model
3. Verify region is `us-east-1`
4. Check CloudFormation stack for IAM role permissions

## Step-by-Step Fix Process

### Step 1: Verify AWS Setup
```bash
# Check if Amplify is configured
npx ampx status

# Deploy backend if needed
npx ampx sandbox
# OR for production
npx ampx push
```

### Step 2: Enable Claude in AWS Console
1. Log into AWS Console
2. Navigate to Amazon Bedrock
3. Go to "Model access" in left sidebar
4. Find "Claude 3 Haiku" and click "Request access"
5. Wait for approval (usually instant)

### Step 3: Verify Permissions
Check that your Amplify backend includes Bedrock permissions:

```typescript
// amplify/backend.ts should contain:
const bedrockPolicy = new Policy(stack, 'BedrockPolicy', {
  statements: [
    new PolicyStatement({
      effect: Effect.ALLOW,
      actions: [
        'bedrock:InvokeModel',
        'bedrock:InvokeModelWithResponseStream',
      ],
      resources: [
        `arn:aws:bedrock:${stack.region}::foundation-model/anthropic.claude-3-haiku-20240307-v1:0`,
      ],
    }),
  ],
});
```

### Step 4: Test in Dev Tools
1. Open the app
2. Go to Settings → Developer Tools
3. Click "Test Bedrock Connection"
4. If still failing, click "Advanced Bedrock Diagnostics"

### Step 5: Check Logs
Enable debug logging to see detailed errors:

```dart
// In your main.dart or where you initialize the app
LoggerService.setLogLevel(LogLevel.debug);
```

## Fallback Behavior

When Bedrock is offline, the bot will show:
- 🔴 Clear error messages indicating the issue
- Basic market data (if available from CoinGecko)
- User profile information
- Helpful troubleshooting tips

## Testing Checklist

- [ ] User is authenticated (logged in)
- [ ] Amplify backend is deployed (`npx ampx status`)
- [ ] Claude 3 Haiku is enabled in AWS Bedrock Console
- [ ] AWS region is set to `us-east-1`
- [ ] Network can reach AWS endpoints
- [ ] No VPN/firewall blocking AWS
- [ ] IAM permissions include Bedrock access

## Need More Help?

1. Check CloudWatch logs in AWS Console
2. Run the Bedrock permission checker in Dev Tools
3. Review `BEDROCK_COMPLETE_GUIDE.md` for setup instructions
4. Check AWS Bedrock quotas and limits

## Error Messages Explained

| Error | Meaning | Fix |
|-------|---------|-----|
| `ENOTFOUND` | Cannot resolve AWS domain | Check network/DNS |
| `AccessDenied` | No permission to use Bedrock | Enable model access |
| `Timeout` | Request took too long | Retry or check network |
| `Invalid credentials` | Auth token expired | Re-login to app |

## Working Response Example

When properly configured, the bot should:
1. Show "Thinking..." indicator
2. Make real API call to Claude
3. Return intelligent, contextual responses
4. Include market data and analysis
5. NOT show "Bot offline" messages