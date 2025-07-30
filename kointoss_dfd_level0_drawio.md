# Kointoss - Data Flow Diagram (Level 0) - Draw.io Instructions

## Context Diagram - Crypto Social Platform

### External Entities (Rectangles with rounded corners):
1. **Guest User**
2. **Registered User** 
3. **System Admin**
4. **CoinGecko API**
5. **AWS Bedrock AI**

### Main Process (Circle):
- **Kointoss Crypto Social Platform (Process 0)**

### Data Stores (Open rectangles):
- **D1: AWS DynamoDB (User Data)**
- **D2: AWS S3 (Media Files)**

### Data Flows (Arrows with labels):

#### FROM External Entities TO System:
- **Guest User** → **Kointoss System**
  - Registration Request
  - Market Data Request
  - Content View Request

- **Registered User** → **Kointoss System**
  - Login Credentials
  - Post/Article Content
  - Portfolio Data
  - Chat Messages
  - Profile Updates

- **System Admin** → **Kointoss System**
  - Admin Commands
  - Content Moderation
  - User Management

- **CoinGecko API** → **Kointoss System**
  - Real-time Crypto Prices
  - Market Statistics
  - Coin Information

- **AWS Bedrock AI** → **Kointoss System**
  - AI Response Data
  - Market Analysis
  - Personalized Insights

#### FROM System TO External Entities:
- **Kointoss System** → **Guest User**
  - Market Data
  - Public Content
  - Registration Confirmation

- **Kointoss System** → **Registered User**
  - Personalized Feed
  - Portfolio Analytics
  - AI Insights
  - Notifications
  - Social Updates

- **Kointoss System** → **System Admin**
  - System Analytics
  - User Reports
  - Content Lists

- **Kointoss System** → **CoinGecko API**
  - API Requests
  - Data Sync Commands

- **Kointoss System** → **AWS Bedrock AI**
  - User Context
  - Market Queries
  - Personalization Data

#### System TO/FROM Data Stores:
- **Kointoss System** ↔ **AWS DynamoDB**
  - User Profiles
  - Posts & Comments
  - Portfolio Data
  - Gamification Stats
  - Articles & Interactions

- **Kointoss System** ↔ **AWS S3**
  - Profile Pictures
  - Post Images
  - Article Media
  - Backup Files

### Layout Suggestion for Draw.io:
```
     Guest User    Registered User    System Admin
          |              |               |
          v              v               v
    ┌─────────────────────────────────────────────┐
    │                                             │
    │        Kointoss Crypto Social Platform      │
    │                 (Process 0)                 │
    │                                             │
    └─────────────────────────────────────────────┘
          ^              ^               ^
          |              |               |
    CoinGecko API   AWS Bedrock AI   [Data Stores]
                                     D1: DynamoDB
                                     D2: S3 Storage
```
