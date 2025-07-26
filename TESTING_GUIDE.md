# Testing Guide for Kointos

## Overview
This document outlines the testing strategy and setup for the Kointos Flutter app with AWS Amplify backend.

## Test Structure

### Unit Tests
- **Location**: `test/` directory
- **Coverage**: Services, repositories, entities
- **Run**: `flutter test` or VS Code task "Flutter: Run Tests"

### Integration Tests
- **Location**: `test/integration_test.dart`
- **Coverage**: Service interactions, API calls
- **Requires**: AWS sandbox environment

## AWS Sandbox Testing

### Setup
The project includes scripts for AWS Amplify sandbox testing:

1. **Start Sandbox**:
   ```bash
   ./setup-test-sandbox.sh
   ```
   - Creates temporary AWS resources
   - Configures test environment
   - Returns sandbox PID for cleanup

2. **Run Tests**:
   ```bash
   flutter test
   ```

3. **Cleanup**:
   ```bash
   ./cleanup-test-sandbox.sh
   ```

### VS Code Tasks
Use the following tasks from the Command Palette (Ctrl+Shift+P):
- `Tasks: Run Task` → `Setup AWS Test Sandbox`
- `Tasks: Run Task` → `Flutter: Run Tests`
- `Tasks: Run Task` → `Cleanup AWS Test Sandbox`

## Test Categories

### 1. Local Storage Tests
- **File**: `test/local_storage_service_test.dart`
- **Tests**: Save, retrieve, expiry, cleanup
- **Mocking**: SharedPreferences

### 2. API Service Tests
- **File**: `test/coingecko_service_test.dart`
- **Tests**: HTTP responses, data parsing
- **Mocking**: HTTP client responses

### 3. Integration Tests
- **File**: `test/integration_test.dart`
- **Tests**: Service locator, end-to-end flows
- **Requires**: AWS sandbox

## Test Data

### Mock Data Patterns
```dart
// Cryptocurrency mock data
final mockCrypto = {
  'id': 'bitcoin',
  'symbol': 'btc',
  'name': 'Bitcoin',
  'current_price': 50000.0,
  'market_cap': 1000000000000.0,
  // ... other fields
};
```

### Environment Variables
Set these for testing:
```bash
export AMPLIFY_ENV=sandbox
export TEST_MODE=true
```

## Best Practices

### 1. Isolation
- Each test should be independent
- Use `setUp()` and `tearDown()` properly
- Mock external dependencies

### 2. AWS Resources
- Always use sandbox for testing
- Clean up resources after testing
- Don't test against production

### 3. Data Mocking
- Mock CoinGecko API responses
- Use SharedPreferences.setMockInitialValues()
- Mock Amplify services for unit tests

## Troubleshooting

### Common Issues

1. **Sandbox startup fails**:
   - Check AWS credentials: `aws sts get-caller-identity`
   - Verify Node.js/npm installation
   - Check network connectivity

2. **Tests fail with auth errors**:
   - Ensure sandbox is running
   - Check Amplify configuration
   - Verify test environment setup

3. **Mock data issues**:
   - Match entity field names exactly
   - Use proper JSON structure
   - Handle nullable fields

### Debug Commands
```bash
# Check AWS credentials
aws sts get-caller-identity

# View sandbox status
cd amplify && npx ampx sandbox --outputs

# Run specific test
flutter test test/local_storage_service_test.dart

# Verbose test output
flutter test --reporter=expanded
```

## Continuous Integration

### GitHub Actions (Future)
```yaml
# .github/workflows/test.yml
- name: Setup AWS Sandbox
  run: ./setup-test-sandbox.sh
  
- name: Run Tests
  run: flutter test
  
- name: Cleanup Sandbox
  run: ./cleanup-test-sandbox.sh
```

This testing setup ensures reliable development and deployment of the Kointos app with proper AWS resource management.
