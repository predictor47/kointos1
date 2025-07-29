# 🔐 Amplify Bedrock Permissions & Query Flow Guide

## 🛡️ **Ensuring Bedrock Permissions**

### 1. **Backend IAM Permissions** (Already Configured ✅)

Your `amplify/backend.ts` already includes the necessary IAM policy:

```typescript
// Add IAM policy for Bedrock access (AI Chatbot)
const bedrockPolicy = new Policy(stack, 'BedrockPolicy', {
  statements: [
    new PolicyStatement({
      effect: Effect.ALLOW,
      actions: [
        'bedrock:InvokeModel',                    // For standard API calls
        'bedrock:InvokeModelWithResponseStream', // For streaming responses
      ],
      resources: [
        // Claude 3 Haiku (primary model)
        `arn:aws:bedrock:${stack.region}::foundation-model/anthropic.claude-3-haiku-20240307-v1:0`,
        // Claude 3 Sonnet (backup/upgrade option)
        `arn:aws:bedrock:${stack.region}::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0`,
        // Claude Instant (legacy fallback)
        `arn:aws:bedrock:${stack.region}::foundation-model/anthropic.claude-instant-v1`,
      ],
    }),
  ],
});

// Attach to authenticated users
backend.auth.resources.authenticatedUserIamRole.attachInlinePolicy(bedrockPolicy);
```

### 2. **Required Steps to Enable Bedrock Access**

#### Step A: Deploy Backend with Permissions
```bash
# Deploy the backend with Bedrock IAM policies
npx ampx sandbox
# or for production
npx ampx pipeline-deploy --branch main
```

#### Step B: Enable Model Access in AWS Console
1. **Go to AWS Bedrock Console**: https://console.aws.amazon.com/bedrock/
2. **Navigate to "Model access"** (left sidebar)
3. **Click "Edit"** or "Manage model access"
4. **Enable these models**:
   - ✅ **Claude 3 Haiku** (anthropic.claude-3-haiku-20240307-v1:0)
   - ✅ **Claude 3 Sonnet** (optional, for better responses)
   - ✅ **Claude Instant** (optional, legacy support)
5. **Submit Request** - Usually auto-approved
6. **Wait for "Access granted"** status

#### Step C: Verify Region Consistency
- Your app uses **us-east-1** region
- Ensure Bedrock models are enabled in **us-east-1**
- All resources (Amplify, Bedrock, Cognito) should be in same region

## 🔄 **Complete Query Flow Architecture**

```mermaid
graph TD
    A[User Types Message] --> B[Chatbot Widget]
    B --> C[KointosAIChatbotService]
    C --> D[LLMService.generateResponse]
    
    D --> E[1. Fetch User Data]
    E --> E1[Amplify GraphQL - UserProfile]
    E1 --> E2[XP, Level, Sentiment History]
    
    D --> F[2. Fetch Article History]
    F --> F1[ArticleRepository]
    F1 --> F2[Recent reads, publications]
    
    D --> G[3. Fetch Market Data]
    G --> G1[Extract crypto symbols from prompt]
    G1 --> G2[CoinGecko API calls]
    G2 --> G3[Real-time prices, 24h changes]
    
    D --> H[4. Build Context Prompt]
    H --> H1[User Profile + Market Data + Articles]
    H1 --> H2[Structured prompt for Claude]
    
    D --> I[5. Call Bedrock API]
    I --> I1[BedrockClient.invokeClaudeModel]
    I1 --> I2[AWS Signature v4 signing]
    I2 --> I3[HTTPS POST to Bedrock Runtime]
    I3 --> I4[Claude 3 Haiku processes prompt]
    I4 --> I5[AI generates contextual response]
    
    I --> J[6. Save Interaction History]
    J --> J1[GraphQL mutation to DynamoDB]
    
    I --> K[7. Return Response to UI]
    K --> L[Chatbot displays AI response]
```

## 📊 **Detailed Query Processing Flow**

### **Phase 1: Context Gathering** (Real-time data fetch)

#### **1.1 User Data Collection**
```dart
// From Amplify GraphQL API
{
  "userId": "user_123",
  "displayName": "CryptoTrader42",
  "xp": 2450,
  "level": "Gold",
  "bullishVotes": 15,
  "bearishVotes": 8,
  "portfolioValue": 12500.50,
  "lastActivity": "2025-07-29T10:30:00Z"
}
```

#### **1.2 Market Data from CoinGecko** (Yes, real-time! 🔥)
```dart
// Extract coins from user prompt
User: "Should I buy Bitcoin and Ethereum?"
Extracted: ["bitcoin", "ethereum"]

// CoinGecko API calls (parallel)
GET https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd&include_24hr_change=true

Response:
{
  "bitcoin": {
    "usd": 67834.50,
    "usd_24h_change": 2.45,
    "usd_market_cap": 1340000000000
  },
  "ethereum": {
    "usd": 3456.78,
    "usd_24h_change": -1.23,
    "usd_market_cap": 415000000000
  }
}
```

#### **1.3 Article History**
```dart
// Recent user articles and engagement
[
  {
    "title": "DeFi Summer 2.0: What to Expect",
    "createdAt": "2025-07-28T15:20:00Z",
    "likesCount": 23,
    "engagement": "high"
  }
]
```

### **Phase 2: Intelligent Prompt Construction**

```dart
// Built contextual prompt for Claude
"""
User: "Should I buy Bitcoin and Ethereum?"

User Profile:
- XP: 2450 (Gold)
- Sentiment: Bullish: 15, Bearish: 8
- Portfolio Value: $12,500.50

Market Data:
- Bitcoin (BTC): $67,834.50 (↑2.45%), Market Cap: $1.34T
- Ethereum (ETH): $3,456.78 (↓1.23%), Market Cap: $415B

Recent Articles:
- "DeFi Summer 2.0: What to Expect"

Instructions:
You are KryptoBot, an intelligent cryptocurrency assistant for the Kointos platform.
Provide a helpful 2-3 paragraph analysis based on the user's experience level, 
sentiment history, and current market data. Use the user's portfolio context 
and recent article engagement to personalize your response. Include relevant 
emojis and keep the tone engaging but professional. Maximum 300 words.
"""
```

### **Phase 3: Bedrock API Execution**

#### **3.1 AWS Authentication Flow**
```dart
// 1. Get Cognito credentials
final authSession = await Amplify.Auth.fetchAuthSession();
final credentials = authSession.credentialsResult.value;

// 2. AWS Signature V4 signing
final signedHeaders = {
  'Authorization': 'AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20250729/us-east-1/bedrock-runtime/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=abc123...',
  'X-Amz-Date': '20250729T103000Z',
  'Content-Type': 'application/json'
};
```

#### **3.2 Bedrock API Call**
```dart
POST https://bedrock-runtime.us-east-1.amazonaws.com/model/anthropic.claude-3-haiku-20240307-v1:0/invoke

Body:
{
  "anthropic_version": "bedrock-2023-05-31",
  "messages": [
    {
      "role": "user",
      "content": [{"type": "text", "text": "User: Should I buy..."}]
    }
  ],
  "max_tokens": 500,
  "temperature": 0.7
}
```

### **Phase 4: AI Response Processing**

#### **Expected Claude 3 Haiku Output:**
```json
{
  "id": "msg_01ABC123",
  "content": [
    {
      "type": "text",
      "text": "🚀 Great question! Looking at your Gold-level experience and bullish sentiment history (15 bullish vs 8 bearish votes), you clearly understand market dynamics.\n\nFor Bitcoin at $67,834 with a +2.45% daily gain, the momentum looks positive, especially given your $12.5K portfolio size. Your recent DeFi article engagement suggests you're staying informed - crucial for timing entries. However, Ethereum's -1.23% dip might present a better opportunity, especially with the upcoming developments you wrote about.\n\n💡 Given your experience level and current portfolio allocation, consider dollar-cost averaging into both positions rather than lump sum investing. Your track record shows good market intuition, but always remember to diversify and never invest more than you can afford to lose! 📊"
    }
  ],
  "stop_reason": "end_turn",
  "usage": {
    "input_tokens": 245,
    "output_tokens": 156
  }
}
```

## 💰 **Cost Breakdown**

### Claude 3 Haiku Pricing:
- **Input tokens**: $0.25 per 1M tokens (~245 tokens = $0.00006)
- **Output tokens**: $1.25 per 1M tokens (~156 tokens = $0.000195)
- **Total per query**: ~$0.000255 (**$0.25 per 1000 conversations**)

### Monthly estimates:
- **100 conversations/day**: ~$7.65/month
- **500 conversations/day**: ~$38.25/month
- **1000 conversations/day**: ~$76.50/month

## 🎯 **Expected Output Characteristics**

### **Response Quality:**
- ✅ **Contextual**: Uses your actual XP level and trading sentiment
- ✅ **Current**: Includes real-time market prices and trends
- ✅ **Personalized**: References your portfolio size and article engagement
- ✅ **Professional**: Maintains appropriate disclaimer language
- ✅ **Actionable**: Provides specific, relevant advice

### **Response Format:**
- 📊 **Emojis**: Relevant crypto/financial icons
- 📈 **Market Data**: Current prices with change indicators
- 💡 **Insights**: Personalized based on user profile
- ⚠️ **Disclaimers**: Appropriate risk warnings
- 🎯 **Length**: 200-300 words (optimized for mobile)

## 🔍 **Testing Your Integration**

### Verify Permissions:
```bash
# 1. Check AWS CLI access (if configured)
aws bedrock list-foundation-models --region us-east-1

# 2. Test in your app with debug logging
LoggerService.info('Testing Bedrock integration...');
```

### Sample Test Queries:
1. **"What's Bitcoin's price?"** → Should return current price with market context
2. **"Should I diversify my portfolio?"** → Should reference your current holdings
3. **"Explain DeFi to me"** → Should adjust complexity based on your XP level

Your integration is production-ready! 🚀
