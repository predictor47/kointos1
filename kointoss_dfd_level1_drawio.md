# Kointoss - Data Flow Diagram (Level 1) - Draw.io Instructions

## System Decomposition - Major Processes

### External Entities (Rectangles with rounded corners):
1. **Guest User**
2. **Registered User**
3. **System Admin** 
4. **CoinGecko API**
5. **AWS Bedrock AI**

### Main Processes (Circles numbered 1.0-7.0):
1. **1.0 Authentication & User Management**
2. **2.0 Social Feed & Interactions**
3. **3.0 Market Data & Portfolio**
4. **4.0 Content Management (Articles)**
5. **5.0 AI Assistant & Insights**
6. **6.0 Gamification & Analytics**
7. **7.0 Notification & Settings**

### Data Stores (Open rectangles D1-D8):
- **D1: User Profiles**
- **D2: Posts & Comments**
- **D3: Articles & Media**
- **D4: Portfolio Data**
- **D5: Market Cache**
- **D6: Gamification Stats**
- **D7: System Settings**
- **D8: Notification Queue**

### Key Data Flows:

#### External Entities to Processes:
- **Guest User** → **1.0 Auth**: Registration Data, Login Attempts
- **Registered User** → **1.0 Auth**: Login Credentials, Profile Updates
- **Registered User** → **2.0 Social**: Post Content, Likes/Comments
- **Registered User** → **3.0 Market**: Portfolio Updates, Watchlist Changes
- **Registered User** → **4.0 Content**: Article Content, Media Uploads
- **Registered User** → **5.0 AI**: Chat Messages, Query Requests
- **System Admin** → **1.0 Auth**: User Management Commands
- **System Admin** → **2.0 Social**: Content Moderation
- **CoinGecko API** → **3.0 Market**: Real-time Prices, Market Data
- **AWS Bedrock AI** → **5.0 AI**: AI Responses, Market Analysis

#### Processes to External Entities:
- **1.0 Auth** → **Registered User**: Authentication Tokens, Profile Data
- **2.0 Social** → **Registered User**: Social Feed, Interaction Updates
- **3.0 Market** → **Registered User**: Portfolio Analytics, Market Updates
- **3.0 Market** → **Guest User**: Public Market Data
- **4.0 Content** → **Registered User**: Published Articles
- **4.0 Content** → **Guest User**: Public Articles
- **5.0 AI** → **Registered User**: AI Responses, Market Insights
- **6.0 Gamification** → **Registered User**: Points & Badges, Leaderboard
- **7.0 Notifications** → **Registered User**: Push Notifications, Alerts

#### Process to Data Store Access:
- **1.0 Auth** ↔ **D1 User Profiles**: User data, authentication info
- **2.0 Social** ↔ **D2 Posts & Comments**: Social content, interactions
- **2.0 Social** → **D1 User Profiles**: Social stats updates
- **3.0 Market** ↔ **D4 Portfolio Data**: Holdings, transaction history
- **3.0 Market** ↔ **D5 Market Cache**: Cached market data, price history
- **4.0 Content** ↔ **D3 Articles & Media**: Articles, content metadata
- **5.0 AI** → **D1 User Profiles**: User interaction history
- **5.0 AI** → **D5 Market Cache**: Market context data
- **6.0 Gamification** ↔ **D6 Gamification Stats**: Points, badges, achievements
- **6.0 Gamification** → **D1 User Profiles**: Gamification updates
- **7.0 Notifications** ↔ **D8 Notification Queue**: Notification delivery
- **7.0 Notifications** ↔ **D7 System Settings**: User preferences

#### Inter-Process Communication:
- **1.0 Auth** → **2.0 Social**: User Authentication Status
- **1.0 Auth** → **3.0 Market**: User Verification
- **1.0 Auth** → **4.0 Content**: Author Verification
- **1.0 Auth** → **5.0 AI**: User Context
- **1.0 Auth** → **6.0 Gamification**: User Activity Data
- **1.0 Auth** → **7.0 Notifications**: User Session Info
- **2.0 Social** → **6.0 Gamification**: Social Actions (for points)
- **2.0 Social** → **7.0 Notifications**: Social Notifications
- **4.0 Content** → **6.0 Gamification**: Content Actions (for points)
- **3.0 Market** → **7.0 Notifications**: Price Alerts
- **6.0 Gamification** → **7.0 Notifications**: Achievement Notifications

### Draw.io Layout Suggestion:
```
External Entities (Top):
Guest User  |  Registered User  |  System Admin  |  CoinGecko API  |  AWS Bedrock

Main Processes (Middle - arranged in 2 rows):
Row 1: [1.0 Auth] [2.0 Social] [3.0 Market] [4.0 Content]
Row 2: [5.0 AI] [6.0 Gamification] [7.0 Notifications]

Data Stores (Bottom - arranged in 2 rows):
Row 1: [D1 User Profiles] [D2 Posts] [D3 Articles] [D4 Portfolio]
Row 2: [D5 Market Cache] [D6 Gamification] [D7 Settings] [D8 Notifications]
```

### Draw.io Creation Steps:
1. **Create External Entities**: Use rounded rectangles at the top
2. **Create Processes**: Use circles in the middle, number them 1.0-7.0
3. **Create Data Stores**: Use open rectangles at the bottom, label D1-D8
4. **Add Data Flows**: Use arrows with labels between components
5. **Use Colors**: 
   - External Entities: Light Green
   - Processes: Light Blue
   - Data Stores: Light Yellow
   - Arrows: Black with readable labels
