# AWS Amplify Full Stack Deployment Guide for Kointoss

## Overview

This guide explains how to deploy both the backend (AWS services) and frontend (Flutter web app) using AWS Amplify.

## What Gets Deployed

### Backend Services (Amplify Gen 2)
- **AWS Cognito**: User authentication and authorization
- **AWS AppSync (GraphQL API)**: Real-time data synchronization
- **AWS DynamoDB**: Database for storing app data
- **AWS S3**: File storage for user uploads
- **Amazon Pinpoint**: Analytics and push notifications
- **AWS Lambda**: Serverless functions for custom logic

### Frontend
- **Flutter Web App**: The compiled Flutter application
- **Static Hosting**: Served via AWS CloudFront CDN

## Deployment Configuration

The `amplify.yml` file is configured to:

1. **Deploy Backend First**:
   ```yaml
   backend:
     phases:
       build:
         commands:
           - npm ci
           - npx ampx pipeline-deploy --branch $AWS_BRANCH --app-id $AWS_APP_ID
   ```
   This creates all AWS resources and generates `amplify_outputs.json`

2. **Build and Deploy Frontend**:
   ```yaml
   frontend:
     phases:
       preBuild:
         commands:
           - Install Flutter SDK
           - Install dependencies
       build:
         commands:
           - Build Flutter web app
   ```

## Deployment Steps

1. **Commit and Push Changes**:
   ```bash
   git add amplify.yml package.json
   git commit -m "Configure full stack Amplify deployment"
   git push
   ```

2. **In AWS Amplify Console**:
   - Navigate to your app
   - Click "Redeploy this version" or wait for automatic build
   - Monitor the build logs

3. **Build Process**:
   - Backend deploys first (creates AWS resources)
   - `amplify_outputs.json` is generated with real endpoints
   - Frontend builds with the real configuration
   - App is deployed to CloudFront

## Post-Deployment Configuration

### 1. Environment Variables (if needed)
In Amplify Console > App settings > Environment variables:
- `COINGECKO_API_KEY`: Your CoinGecko API key (if using paid tier)
- `FCM_SERVER_KEY`: Firebase Cloud Messaging key for push notifications

### 2. Domain Configuration
- Go to Domain management in Amplify Console
- Add your custom domain
- Follow DNS configuration instructions

### 3. Test the Deployment
Once deployed, test:
- User registration and login
- Data persistence (posts, portfolios)
- Real-time features (chat, notifications)
- Admin dashboard access (web-only)

## Monitoring and Logs

### CloudWatch Logs
- API Gateway logs: `/aws/appsync/apis/{api-id}`
- Lambda function logs: `/aws/lambda/{function-name}`
- Amplify build logs: Available in Amplify Console

### Pinpoint Analytics
- User engagement metrics
- Custom events tracking
- Push notification delivery rates

## Troubleshooting

### Build Failures

1. **"Module not found" errors**:
   - Ensure all dependencies are in `package.json`
   - Check for case-sensitive file imports

2. **"amplify_outputs.json not found"**:
   - Backend deployment may have failed
   - Check CloudFormation stack status in AWS Console

3. **Flutter build errors**:
   - Review Flutter version compatibility
   - Check for platform-specific code that needs web alternatives

### Runtime Issues

1. **Authentication not working**:
   - Verify Cognito User Pool is created
   - Check CORS settings in API Gateway

2. **API calls failing**:
   - Confirm AppSync endpoint is accessible
   - Verify GraphQL schema matches queries

3. **Storage uploads failing**:
   - Check S3 bucket permissions
   - Verify CORS configuration on S3 bucket

## Cost Considerations

With full deployment, you'll be using:
- **Cognito**: Free tier covers 50,000 MAUs
- **AppSync**: $4/million requests after free tier
- **DynamoDB**: On-demand pricing, very cost-effective for small apps
- **S3**: $0.023/GB storage + transfer costs
- **Pinpoint**: Free tier includes 100M events/month
- **CloudFront**: Free tier includes 1TB transfer/month

## Security Best Practices

1. **API Keys**: Never commit API keys to repository
2. **Authentication**: Enable MFA for admin users
3. **Data Access**: Use fine-grained IAM policies
4. **Monitoring**: Set up CloudWatch alarms for unusual activity

## Next Steps

After successful deployment:
1. Set up monitoring dashboards
2. Configure backup strategies
3. Plan for scaling (if needed)
4. Implement CI/CD pipelines for automated deployments

## Support Resources

- [AWS Amplify Documentation](https://docs.amplify.aws/)
- [Flutter Web Documentation](https://flutter.dev/web)
- [AWS Support](https://aws.amazon.com/support/)