# Amplify Flutter Deployment Guide for Kointoss

## Overview
This guide will help you deploy the Kointoss Flutter app using AWS Amplify Hosting with proper configuration for both backend (Amplify Gen 2) and frontend (Flutter Web).

## Prerequisites
1. AWS Account with appropriate permissions
2. Flutter SDK installed (3.0 or higher)
3. Node.js 18+ installed
4. AWS Amplify CLI installed (`npm install -g @aws-amplify/cli`)

## Step 1: Prepare Your App for Web Deployment

### 1.1 Enable Web Support
```bash
flutter config --enable-web
```

### 1.2 Test Web Build Locally
```bash
flutter build web --release
flutter run -d chrome
```

## Step 2: Initialize Amplify in Your Project

### 2.1 If Not Already Initialized
```bash
amplify init
```

Choose the following options:
- Enter a name for the project: `kointoss`
- Initialize the project with the above configuration? `Yes`
- Select the authentication method: `AWS profile`

### 2.2 Add Hosting
```bash
amplify add hosting
```

Choose:
- Select the plugin module to execute: `Hosting with Amplify Console`
- Choose a type: `Manual deployment`

## Step 3: Configure Build Settings

The following files have already been created for you:

### 3.1 `amplify.yml` (Build Configuration)
This file tells Amplify how to build your Flutter web app:
- Pre-build: Installs Flutter dependencies
- Build: Creates optimized web build
- Artifacts: Specifies build output directory
- Cache: Optimizes subsequent builds

### 3.2 `package.json` (Project Metadata)
Helps Amplify recognize the project structure and provides build scripts.

### 3.3 `amplify/hosting/amplifyhosting.yml` (Hosting Configuration)
Configures:
- Cache headers for optimal performance
- SPA routing for Flutter web

## Step 4: Deploy to Amplify

### 4.1 Push Backend Changes
```bash
cd amplify
npm install
npx ampx sandbox
# Or for production:
npx ampx pipeline-deploy --branch main --app-id YOUR_APP_ID
```

### 4.2 Deploy Frontend

#### Option A: Manual Deployment
1. Build the web app:
   ```bash
   flutter build web --release
   ```

2. Deploy to Amplify:
   ```bash
   amplify publish
   ```

#### Option B: Continuous Deployment (Recommended)
1. Push your code to a Git repository (GitHub, GitLab, Bitbucket, or CodeCommit)

2. In AWS Amplify Console:
   - Click "Connect app"
   - Choose your Git provider
   - Select your repository and branch
   - Amplify will auto-detect the build settings from `amplify.yml`
   - Click "Save and deploy"

## Step 5: Environment Variables

Add these environment variables in Amplify Console:
- `FLUTTER_VERSION`: Specify Flutter version (e.g., `3.19.0`)
- `AMPLIFY_FLUTTER_ANDROID_MIN_SDK_VERSION`: `21` (if needed)

## Step 6: Post-Deployment Configuration

### 6.1 Configure Custom Domain (Optional)
1. In Amplify Console, go to "Domain management"
2. Add your custom domain
3. Follow DNS configuration instructions

### 6.2 Enable Web App Manifest
Ensure `web/manifest.json` is properly configured for PWA support.

### 6.3 Configure CORS (if needed)
If your app makes API calls, ensure CORS is configured in your backend:
```typescript
// In amplify/backend.ts
backend.addOutput({
  custom: {
    API: {
      GraphQL: {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "*"
        }
      }
    }
  }
});
```

## Troubleshooting

### Issue: Amplify doesn't detect Flutter
**Solution**: Ensure `amplify.yml` and `package.json` are in the root directory.

### Issue: Build fails with Flutter not found
**Solution**: Add Flutter installation to build commands:
```yaml
preBuild:
  commands:
    - git clone https://github.com/flutter/flutter.git -b stable
    - export PATH="$PATH:`pwd`/flutter/bin"
    - flutter --version
    - flutter pub get
```

### Issue: 404 errors on page refresh
**Solution**: The `amplifyhosting.yml` redirect rule should handle this. If not, check the regex pattern.

### Issue: Large build size
**Solution**: Enable tree shaking and minification:
```bash
flutter build web --release --tree-shake-icons
```

## Build Optimization Tips

1. **Enable Compression**: Amplify automatically serves gzipped files
2. **Use CDN**: Amplify includes CloudFront CDN by default
3. **Optimize Images**: Use WebP format and lazy loading
4. **Code Splitting**: Flutter web automatically splits code

## Monitoring and Analytics

1. **CloudWatch Logs**: Monitor build logs in CloudWatch
2. **Amplify Console**: View deployment history and metrics
3. **Pinpoint Analytics**: Track user engagement (already configured)

## Security Best Practices

1. **Environment Variables**: Never commit sensitive data
2. **HTTPS**: Amplify provides SSL certificates automatically
3. **CSP Headers**: Configure Content Security Policy in `amplifyhosting.yml`
4. **API Keys**: Use AWS Secrets Manager for sensitive keys

## Useful Commands

```bash
# View Amplify status
amplify status

# Pull backend environment
amplify pull --appId YOUR_APP_ID --envName main

# Open Amplify Console
amplify console

# View logs
amplify console logs

# Delete resources (careful!)
amplify delete
```

## Next Steps

1. Set up monitoring alerts in CloudWatch
2. Configure backup and disaster recovery
3. Implement CI/CD pipeline with automated testing
4. Set up staging environments

## Support

For issues specific to:
- Flutter: https://flutter.dev/docs
- Amplify: https://docs.amplify.aws/
- This project: Check the project documentation

Remember to regularly update dependencies and monitor AWS costs!