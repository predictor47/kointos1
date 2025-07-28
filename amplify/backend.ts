import { defineBackend } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { data } from './data/resource';
import { storage } from './storage/resource';
import { Policy, PolicyStatement, Effect } from 'aws-cdk-lib/aws-iam';
import { CfnApp } from 'aws-cdk-lib/aws-pinpoint';
import { Topic } from 'aws-cdk-lib/aws-sns';
import { CfnUserPoolGroup } from 'aws-cdk-lib/aws-cognito';

/**
 * @see https://docs.amplify.aws/gen2/build-a-backend/ to add other resources
 */
export const backend = defineBackend({
  auth,
  data,
  storage,
});

// Get the underlying CDK stack
const { cfnUserPool } = backend.auth.resources.cfnResources;
const stack = backend.auth.resources.userPool.stack;

// Create admin groups
new CfnUserPoolGroup(stack, 'AdminGroup', {
  userPoolId: cfnUserPool.ref,
  groupName: 'Admins',
  description: 'Admin users with full access',
  precedence: 1,
});

new CfnUserPoolGroup(stack, 'ModeratorGroup', {
  userPoolId: cfnUserPool.ref,
  groupName: 'Moderators',
  description: 'Moderators with limited admin access',
  precedence: 2,
});

// Create Pinpoint app for analytics
const pinpointApp = new CfnApp(stack, 'KointossPinpointApp', {
  name: 'Kointoss',
});

// Create SNS topic for push notifications
const pushNotificationTopic = new Topic(stack, 'KointossPushNotifications', {
  displayName: 'Kointoss Push Notifications',
  topicName: 'kointoss-push-notifications',
});

// Add IAM policy for authenticated users to access Pinpoint
const pinpointPolicy = new Policy(stack, 'PinpointPolicy', {
  statements: [
    new PolicyStatement({
      effect: Effect.ALLOW,
      actions: [
        'mobiletargeting:PutEvents',
        'mobiletargeting:UpdateEndpoint',
        'mobiletargeting:GetEndpoint',
      ],
      resources: [
        `arn:aws:mobiletargeting:${stack.region}:${stack.account}:apps/${pinpointApp.ref}/*`,
      ],
    }),
  ],
});

// Add IAM policy for SNS access
const snsPolicy = new Policy(stack, 'SNSPolicy', {
  statements: [
    new PolicyStatement({
      effect: Effect.ALLOW,
      actions: [
        'sns:Subscribe',
        'sns:Unsubscribe',
        'sns:Publish',
      ],
      resources: [pushNotificationTopic.topicArn],
    }),
  ],
});

// Attach policies to authenticated role
backend.auth.resources.authenticatedUserIamRole.attachInlinePolicy(pinpointPolicy);
backend.auth.resources.authenticatedUserIamRole.attachInlinePolicy(snsPolicy);

// Export Pinpoint app ID and SNS topic ARN for use in the app
backend.addOutput({
  custom: {
    PinpointAppId: pinpointApp.ref,
    SNSTopicArn: pushNotificationTopic.topicArn,
  },
});