import { defineFunction } from '@aws-amplify/backend';

export const bedrockFunction = defineFunction({
  name: 'bedrock-function',
  entry: './bedrock-handler.ts',
  runtime: 18,
  timeoutSeconds: 300,
});
