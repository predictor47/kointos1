wh# Kointos - AI Coding Instructions

## Architecture Overview

**Kointos** is a Flutter crypto portfolio and social platform with AWS Amplify Gen 2 backend. The app combines real-time market data, portfolio tracking, social features, and gamification.

### Core Tech Stack
- **Frontend**: Flutter with clean architecture (presentation → domain → data)
- **Backend**: AWS Amplify Gen 2 (Cognito Auth, GraphQL API, S3 Storage, DynamoDB)
- **External APIs**: CoinGecko for real-time crypto market data
- **State Management**: Provider pattern with service locator (GetIt)

## Project Structure Patterns

### Service Architecture
All services are registered in `lib/core/services/service_locator.dart` using GetIt:
```dart
// Services are singleton and injected via GetIt pattern
serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
```

### Data Layer Pattern
- **Repositories** (`lib/data/repositories/`) handle business logic and caching
- **DataSources** (`lib/data/datasources/`) handle external API calls
- **Entities** (`lib/domain/entities/`) define data models

Example: `CryptocurrencyRepository` caches CoinGecko data locally and handles API failures gracefully.

### Amplify Integration
- Amplify is configured once at app startup in `lib/core/services/kointos_amplify_config.dart`
- GraphQL operations use raw queries/mutations in `ApiService` for full control
- Owner-based authorization ensures users only access their own data

## Development Workflows

### Build & Run
```bash
# Essential command - always run after pulling changes
flutter pub get

# Use the VS Code task for dependencies
# Task: "Flutter: Get Dependencies"
```

### Testing
```bash
# Run unit tests
flutter test

# Use VS Code tasks for testing workflow:
# - "Flutter: Run Tests"
# - "Setup AWS Test Sandbox" (for integration tests)
# - "Cleanup AWS Test Sandbox"
```

### Code Quality
```bash
# Check for issues
flutter analyze

# Fix common theme/import issues (if needed)
./fix-theme-imports.sh
./fix-theme-properties.sh
```

### Backend Development
- Schema changes: Edit `amplify/data/resource.ts` (TypeScript)
- Deploy backend: Run `./deploy-backend.sh` script
- Generate Dart models: Backend deployment auto-generates `lib/amplify_outputs.dart`

### Key Services to Understand
1. **ApiService** - All backend GraphQL operations (articles, profiles, etc.)
2. **AuthService** - Amplify Cognito authentication wrapper
3. **CoinGeckoService** - External crypto market data with caching
4. **StorageService** - S3 file uploads with URL generation

## Kointos-Specific Conventions

### Navigation Structure
- **Bottom Navigation**: Feed → Articles → Leaderboard → Profile
- **Main Entry**: `MainTabScreen` with tab controller and animations
- **Auth Flow**: Check authentication state in `AppEntryPoint`

### UI/Theme Patterns
- **Dark Theme**: Consistent black/white/gold crypto aesthetic in `AppTheme`
- **Animations**: Flutter Animate library for micro-interactions
- **Responsive**: Custom responsive breakpoints, not Flutter's defaults

### Data Handling
- **Caching Strategy**: Local storage for crypto data, Amplify for user data
- **Error Handling**: Repository pattern abstracts API failures
- **Real-time Updates**: 30-second refresh cycles for market data

### File Organization
- **Screens**: Main app screens in `lib/presentation/screens/`
- **Widgets**: Reusable components in `lib/presentation/widgets/`
- **Core Services**: Business logic in `lib/core/services/`
- **Constants**: App-wide constants in `lib/core/constants/`

## Critical Integration Points

### GraphQL Operations
Raw GraphQL in `ApiService` for articles, profiles, interactions:
```dart
const query = '''
  query GetArticle(\$id: ID!) {
    getArticle(id: \$id) { id title content ... }
  }
''';
```

### External Dependencies
- **CoinGecko API**: Free tier, rate-limited, cached locally
- **Amplify Storage**: S3 URLs for user-generated content
- **Flutter Animate**: Timeline-based animations, not traditional AnimationController

### Authentication Flow
- Users must be authenticated for all backend operations
- JWT tokens managed automatically by Amplify
- Owner-based authorization prevents cross-user data access

## Common Development Tasks

### Adding New Features
1. Define entity in `lib/domain/entities/`
2. Add GraphQL schema in `amplify/data/resource.ts`
3. Implement repository in `lib/data/repositories/`
4. Register services in `service_locator.dart`
5. Create UI in `lib/presentation/`

### API Integration
- Prefer repository pattern over direct API calls in UI
- Cache external API responses locally
- Handle offline scenarios gracefully
- Use `LoggerService` for debugging API issues

### UI Development
- Follow existing animation patterns in `MainTabScreen`
- Use `AppTheme` constants for consistent styling
- Implement responsive design for crypto trading context
- Add loading states for all async operations
