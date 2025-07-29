# AWS Bedrock Integration for Kointos Chatbot

## Overview
Your Kointos app has been successfully upgraded to use **AWS Bedrock with Claude 3 Haiku** for intelligent chatbot responses. The integration replaces the previous mock responses with real AI-powered conversations.

## What's Been Implemented

### 1. Backend Configuration (`amplify/backend.ts`)
- Added **Bedrock IAM permissions** for authenticated users
- Enabled access to Claude 3 Haiku, Claude 3 Sonnet, and Claude Instant models
- Permissions include `bedrock:InvokeModel` and `bedrock:InvokeModelWithResponseStream`

### 2. Bedrock Client (`lib/core/services/bedrock_client.dart`)
- **AWS Signature Version 4 signing** for secure API calls
- Direct HTTP client integration with Bedrock Runtime API
- Automatic credential management through Amplify Auth
- Support for Claude 3 Haiku model with customizable parameters

### 3. Enhanced LLM Service (`lib/core/services/llm_service.dart`)
- Real-time **market data integration** from CoinGecko API
- **User profile context** from Amplify DataStore
- **Article history** and engagement data
- Structured prompts with user XP, sentiment history, and portfolio data
- Interaction history saving to GraphQL backend

### 4. Service Locator Integration
- BedrockClient registered as a singleton service
- Proper dependency injection throughout the app
- Easy testing and mocking capabilities

## Key Features

### Smart Context Awareness
The chatbot now includes:
- **User Experience Level**: Based on XP and platform engagement
- **Trading Sentiment**: Bullish/bearish voting history
- **Portfolio Context**: Current holdings and performance data
- **Market Data**: Real-time cryptocurrency prices and trends
- **Article Engagement**: Recent reads and publications

### AI Model Configuration
- **Model**: Claude 3 Haiku (optimized for speed and cost)
- **Max Tokens**: 500 (configurable)
- **Temperature**: 0.7 (balanced creativity)
- **Stop Sequences**: Proper conversation boundaries

### Security Features
- AWS IAM-based access control
- Cognito session token authentication
- Secure credential management
- Request signing for all API calls

## How It Works

1. **User asks question** → Chatbot widget captures input
2. **Context gathering** → System fetches user profile, market data, articles
3. **Prompt construction** → Creates structured prompt with all context
4. **Bedrock call** → Securely invokes Claude 3 Haiku via AWS API
5. **Response processing** → Formats and displays AI response
6. **History saving** → Stores interaction for future context

## Testing the Integration

### Prerequisites
- Deployed Amplify backend with Bedrock permissions
- Authenticated user session
- AWS Bedrock access enabled in your AWS account

### Quick Test
1. Open the app and authenticate
2. Open the chatbot (floating widget or dedicated screen)
3. Ask: "What's the current Bitcoin price?"
4. The AI should respond with real market data and personalized insights

### Troubleshooting

#### Common Issues:
1. **"Bot is temporarily offline"** → Check AWS Bedrock access in your region
2. **Authentication errors** → Ensure user is logged in with Cognito
3. **Permission denied** → Verify Bedrock IAM policies are deployed
4. **Timeout errors** → Check network connectivity and AWS service status

#### Debug Steps:
1. Check Flutter logs for Bedrock client errors
2. Verify AWS credentials in Amplify Auth session
3. Test with simple prompts first
4. Check AWS CloudWatch logs for Bedrock API calls

## Cost Optimization

### Claude 3 Haiku Pricing (approximate):
- **Input tokens**: $0.25 per 1M tokens
- **Output tokens**: $1.25 per 1M tokens
- **Average conversation**: ~$0.001-0.003 per exchange

### Optimization Features:
- 500 token limit per response
- Context caching for repeated data
- Efficient prompt construction
- User session-based rate limiting

## Deployment Instructions

### 1. Deploy Backend
```bash
npx ampx sandbox
# or for production
npx ampx pipeline-deploy --branch main
```

### 2. Enable Bedrock in AWS Console
1. Go to AWS Bedrock console
2. Navigate to "Model access"
3. Enable "Claude 3 Haiku" model
4. Confirm access is granted

### 3. Test Integration
```bash
flutter test test/bedrock_integration_test.dart
```

### 4. Build and Deploy Frontend
```bash
flutter build web --release
```

## Advanced Configuration

### Custom Model Parameters
Edit `bedrock_client.dart` to modify:
- `maxTokens`: Response length limit
- `temperature`: Creativity level (0.0-1.0)
- `stopSequences`: Conversation boundaries

### Enhanced Context
Extend `llm_service.dart` to include:
- Social media sentiment
- News analysis
- Technical indicators
- Community discussions

## Security Considerations

✅ **Implemented**:
- IAM role-based access control
- Request signing with AWS4-HMAC-SHA256
- Session token validation
- Secure credential management

⚠️ **Recommendations**:
- Monitor API usage and costs
- Implement rate limiting per user
- Log sensitive interactions carefully
- Regular security audits

## Next Steps

1. **Monitor Usage**: Set up CloudWatch alarms for costs
2. **Enhanced Features**: Add conversation memory, file attachments
3. **Performance**: Implement response caching
4. **Analytics**: Track chatbot effectiveness metrics

Your chatbot is now powered by Claude 3 Haiku and ready to provide intelligent, context-aware responses! 🚀
