# 🤖 Claude 3 Haiku LLM Integration Guide

## ✅ **MIGRATION COMPLETE: Gemini/OpenRouter → Amazon Bedrock Claude 3 Haiku**

The Kointos LLM service has been completely migrated from Gemini/OpenRouter to Amazon Bedrock Claude 3 Haiku with full real data integration.

---

## 🎯 **Implementation Overview**

### **What Was Changed**
- ❌ **REMOVED**: All Gemini API integration
- ❌ **REMOVED**: All OpenRouter API integration  
- ❌ **REMOVED**: All mock data and placeholder responses
- ✅ **ADDED**: Amazon Bedrock Claude 3 Haiku integration
- ✅ **ADDED**: Real user data fetching from Amplify DataStore
- ✅ **ADDED**: Live CoinGecko market data integration
- ✅ **ADDED**: User interaction history tracking

### **Architecture Flow**
```
User Message → Fetch Real User Data → Extract Coins → 
Fetch Market Data → Build Claude Prompt → Call Bedrock → 
Save Interaction → Return Response
```

---

## 📊 **Real Data Integration**

### **1. User Data (Amplify DataStore)**
```dart
// Fetches real user profile data
{
  'userId': 'user123',
  'displayName': 'CryptoTrader',
  'xp': 4200,
  'level': 'Gold',           // Calculated: Bronze→Silver→Gold→Diamond
  'bullishVotes': 11,        // Real sentiment history
  'bearishVotes': 3,
  'portfolioValue': 25432.50 // Live portfolio value
}
```

### **2. Market Data (CoinGecko API)**
```dart
// Live cryptocurrency prices with rate limiting
{
  'name': 'Bitcoin',
  'symbol': 'BTC',
  'price': 43256.78,
  'change24h': 2.34,         // Real 24h percentage change
  'marketCap': 847500000000  // Live market capitalization
}
```

### **3. Article History**
```dart
// User's recent article interactions
[
  {'title': 'ETH Market Outlook', 'tags': ['ethereum', 'defi']},
  {'title': 'Bitcoin Halving Analysis', 'tags': ['bitcoin', 'mining']},
  {'title': 'Solana Ecosystem Growth', 'tags': ['solana', 'nft']}
]
```

---

## 🚀 **Claude 3 Haiku Integration**

### **Model Configuration**
- **Model**: `anthropic.claude-3-haiku-20240307-v1:0`
- **Region**: `us-east-1`
- **Max Tokens**: 500
- **Temperature**: 0.7
- **Top P**: 0.9

### **Prompt Structure**
```
User: "Should I hold or sell ETH?"

User Profile:
- XP: 4200 (Gold)
- Sentiment: Bullish: 11, Bearish: 3
- Portfolio Value: $25,432.50

Market Data:
- Ethereum (ETH): $2,100.45 (↑2.3%), Market Cap: $252.4B
- Bitcoin (BTC): $43,256.78 (↑1.8%), Market Cap: $847.5B

Recent Articles:
- "ETH Market Outlook"
- "DeFi Protocol Analysis"
- "Layer 2 Scaling Solutions"

Instructions:
You are KryptoBot, provide 2-3 paragraph analysis...
```

### **Response Processing**
- Safe JSON parsing for Claude responses
- Structured fallback for API failures
- User context preserved in responses
- Interaction logging to CloudWatch

---

## 🔧 **Production Setup**

### **1. AWS Bedrock Configuration**
```bash
# Set up AWS credentials
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set region us-east-1

# Enable Claude 3 Haiku model access in Bedrock console
# Navigate to: Amazon Bedrock → Model Access → Request Access
```

### **2. IAM Permissions**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel"
      ],
      "Resource": [
        "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240307-v1:0"
      ]
    }
  ]
}
```

### **3. Environment Variables**
```bash
# AWS configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# CoinGecko (free tier)
COINGECKO_API_URL=https://api.coingecko.com/api/v3
```

---

## 📋 **Key Features**

### **✅ Real Data Only**
- No mock responses or placeholder data
- Live market prices from CoinGecko
- Actual user XP, sentiment, and portfolio data
- Real article interaction history

### **✅ Intelligent Coin Detection**
```dart
// Automatically detects mentioned cryptocurrencies
"Should I buy ETH or SOL?" → Fetches Ethereum & Solana data
"What about Bitcoin?" → Fetches Bitcoin data
"Market outlook?" → Fetches top trending coins
```

### **✅ Context-Aware Responses**
- Personalizes based on user XP level (Bronze/Silver/Gold/Diamond)
- References actual sentiment voting history
- Considers real portfolio value and performance
- Mentions user's recent article engagement

### **✅ Production Error Handling**
```dart
// Graceful fallbacks at every level
try {
  return await claudeResponse;
} catch (bedrockError) {
  return structuredFallbackWithRealData();
} catch (dataError) {
  return "Bot temporarily offline. Try again."
}
```

---

## 🧪 **Testing & Validation**

### **Test Scenarios**
1. **Price Query**: "What's the current BTC price?"
   - ✅ Fetches live Bitcoin data from CoinGecko
   - ✅ Uses user's XP level for response complexity
   - ✅ References user's bullish/bearish history

2. **Portfolio Analysis**: "How's my portfolio doing?"
   - ✅ Uses real portfolio value from DataStore
   - ✅ Compares with current market conditions
   - ✅ Provides personalized advice based on experience level

3. **Educational**: "Explain DeFi to me"
   - ✅ Adjusts explanation complexity to user's XP level
   - ✅ References user's recent DeFi article interactions
   - ✅ Provides current market context

### **Error Scenarios**
- ❌ Bedrock API timeout → Safe fallback with real data
- ❌ CoinGecko rate limit → Use cached data + explanation
- ❌ User data fetch fails → Generic response with apology

---

## 📈 **Performance & Monitoring**

### **Metrics to Track**
- Claude response time (target: <3 seconds)
- CoinGecko API success rate (target: >95%)
- User data fetch success rate (target: >99%)
- Bedrock token usage per request

### **Logging Strategy**
```dart
LoggerService.info('Claude request: userId=$userId, coins=$extractedCoins');
LoggerService.info('Market data fetched: ${marketData.length} coins');
LoggerService.info('Claude response generated: ${response.length} chars');
LoggerService.error('Bedrock failed: $error, using fallback');
```

---

## 🚀 **Deployment Steps**

### **1. Update Dependencies**
```bash
flutter pub get
```

### **2. Deploy Amplify Backend**
```bash
cd amplify && npx ampx sandbox deploy --name production
```

### **3. Configure AWS Bedrock**
- Enable Claude 3 Haiku model access
- Set up IAM permissions
- Configure AWS credentials

### **4. Test Integration**
```bash
flutter test test/services/llm_service_test.dart
flutter run --release
```

---

## 🎯 **Usage Examples**

### **Price Analysis**
```
User: "Should I buy more ETH?"

Response: "📊 Based on ETH's current price of $2,100.45 (↑2.3% today) and your Gold-level experience, here's my analysis:

Given your predominantly bullish sentiment history (11 bullish vs 3 bearish votes), you've shown good market intuition. ETH's recent 2.3% gain reflects positive momentum, and with a $252.4B market cap, it remains a solid Layer-1 play.

Your portfolio value of $25,432.50 suggests you're an experienced trader. Consider your current ETH allocation and DCA strategy. The Layer 2 scaling solutions you've been reading about could drive further adoption. What's your target allocation percentage?"
```

### **Portfolio Review**
```
User: "How's my crypto portfolio performing?"

Response: "💼 Your portfolio is currently valued at $25,432.50, showing your Gold-level trading experience:

Based on today's market movements, your diversified approach aligns well with current conditions. Your recent engagement with articles like 'DeFi Protocol Analysis' shows you're staying informed about emerging opportunities.

With your bullish sentiment history and active research habits, you're well-positioned for the current market cycle. Consider reviewing your positions against the latest market data I've provided. Any specific holdings you'd like me to analyze further?"
```

---

## ✅ **Migration Checklist**

- [x] Remove all Gemini/OpenRouter code
- [x] Implement Bedrock Claude 3 Haiku integration
- [x] Add real user data fetching from Amplify
- [x] Integrate live CoinGecko market data
- [x] Build contextual prompts with real data
- [x] Implement interaction history tracking
- [x] Add comprehensive error handling
- [x] Create structured fallback responses
- [x] Add AWS dependencies to pubspec.yaml
- [x] Document complete integration process

**🎉 The migration is complete and production-ready!**

---

*Generated: ${DateTime.now().toIso8601String()}*
*Claude Model: anthropic.claude-3-haiku-20240307-v1:0*
*Integration: Amazon Bedrock + Amplify DataStore + CoinGecko API*
