# Kointos Backend - Amplify Gen 2

This document describes the new Amplify Gen 2 backend setup for the Kointos crypto portfolio and social trading platform.

## 🏗️ Architecture

The backend is built using AWS Amplify Gen 2 with the following resources:

### Authentication (`amplify/auth/resource.ts`)
- **Email-based authentication** with Cognito User Pool
- **User attributes**: email, given_name, family_name, picture, preferred_username
- **Account recovery** via email
- **Password policy** with complexity requirements

### Data Layer (`amplify/data/resource.ts`)
The GraphQL API includes comprehensive models for:

#### Core Models
- **UserProfile**: User information and portfolio statistics
- **Cryptocurrency**: Market data for supported cryptocurrencies
- **Portfolio**: User portfolios with public/private visibility
- **PortfolioHolding**: Individual cryptocurrency holdings
- **Transaction**: Buy/sell/transfer transaction history

#### Social Features
- **Post**: Social media posts with images and crypto mentions
- **Comment**: Comments on posts
- **Like**: Likes for posts and comments
- **Follow**: User follow relationships

#### Trading Features
- **TradingSignal**: Buy/sell/hold signals with confidence ratings
- **Watchlist**: Custom cryptocurrency watchlists
- **PriceAlert**: Price-based notifications

#### Content
- **NewsArticle**: Cryptocurrency news with sentiment analysis

### Storage (`amplify/storage/resource.ts`)
- **Profile pictures**: User-specific upload access
- **Post images**: User-specific upload access
- **Public assets**: Read access for all authenticated users

## 🚀 Deployment

### Prerequisites
1. **AWS CLI** configured with appropriate credentials
2. **Node.js** (v18+ recommended)
3. **npm** package manager

### Quick Start
1. **Configure AWS credentials**:
   ```bash
   npx ampx configure profile
   ```

2. **Deploy the backend**:
   ```bash
   ./deploy-backend.sh
   ```

3. **Generate Flutter configuration**:
   ```bash
   npx ampx generate outputs --format dart --out-dir ./lib
   ```

### Manual Deployment
```bash
# Install dependencies
npm install

# Start development environment
npx ampx sandbox

# For production deployment
npx ampx pipeline-deploy --branch main
```

## 📱 Flutter Integration

### Dependencies
The following Amplify Flutter packages are included:
```yaml
dependencies:
  amplify_flutter: ^2.6.1
  amplify_auth_cognito: ^2.6.1
  amplify_api: ^2.6.1
  amplify_storage_s3: ^2.6.1
```

### Configuration
The app is configured to use Amplify Gen 2 outputs in `lib/core/services/kointos_amplify_config.dart`.

### Generated Code
After deployment, generate the data models:
```bash
npx ampx generate graphql-client-code --out-dir ./lib/models
```

## 🔧 Development Workflow

### 1. Schema Changes
Edit `amplify/data/resource.ts` to modify the GraphQL schema.

### 2. Deploy Changes
```bash
npx ampx sandbox
```

### 3. Generate Updated Models
```bash
npx ampx generate graphql-client-code --out-dir ./lib/models
npx ampx generate outputs --format dart --out-dir ./lib
```

### 4. Test in Flutter
```bash
flutter clean
flutter pub get
flutter run
```

## 🛠️ Useful Commands

### Backend Management
```bash
# View current deployments
npx ampx list

# Delete sandbox environment
npx ampx sandbox delete

# Open AWS console
npx ampx console

# View logs
npx ampx logs
```

### Code Generation
```bash
# Generate GraphQL client code
npx ampx generate graphql-client-code

# Generate configuration outputs
npx ampx generate outputs

# Generate both with specific formats
npx ampx generate graphql-client-code --format dart --out-dir ./lib/models
npx ampx generate outputs --format dart --out-dir ./lib
```

## 📊 Data Models

### Authorization
- **Owner-based**: Users can only access their own data
- **Authenticated**: All authenticated users can read certain public data
- **Public**: Some data (like news) is readable by all authenticated users

### Key Relationships
- Users have multiple Portfolios
- Portfolios contain PortfolioHoldings
- Users can create Posts and Comments
- Users can follow each other
- TradingSignals are shared publicly but owned by creators

## 🔐 Security

### Authentication
- Uses Cognito User Pool for user management
- Email-based login with secure password requirements
- JWT tokens for API authorization

### Authorization
- Row-level security with owner-based access
- Fine-grained permissions per model
- Separate access patterns for private vs public data

### Storage
- User-isolated file uploads
- Secure S3 presigned URLs
- Automatic file organization by user identity

## 🚀 Next Steps

1. **Deploy the backend** using the provided script
2. **Generate configuration files** for Flutter
3. **Update Flutter app** to use new models and APIs
4. **Test authentication flow** with new Cognito setup
5. **Implement data operations** using generated GraphQL client
6. **Set up CI/CD pipeline** for automated deployments

## 📝 Notes

- Replace placeholder values in `amplify_outputs.dart` after deployment
- The schema includes comprehensive models for a crypto trading platform
- All models follow best practices for GraphQL and Amplify Gen 2
- Storage is configured for profile pictures and post images
- Social features include following, posts, comments, and likes
- Trading features include signals, watchlists, and price alerts
