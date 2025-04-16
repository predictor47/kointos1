import { defineAuth } from '@aws-amplify/backend';

export const auth = defineAuth({
  name: 'kointos-auth',
  loginWith: {
    email: true
  }
});