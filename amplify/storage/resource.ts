import { defineStorage } from '@aws-amplify/backend';

export const storage = defineStorage({
  name: 'kointosStorage',
  access: (allow) => ({
    'profile-pictures/{entity_id}/*': [
      allow.entity('identity').to(['read', 'write', 'delete']),
    ],
    'post-images/{entity_id}/*': [
      allow.entity('identity').to(['read', 'write', 'delete']),
    ],
    'public-assets/*': [
      allow.authenticated.to(['read']),
      allow.guest.to(['read']),
    ],
  }),
});
