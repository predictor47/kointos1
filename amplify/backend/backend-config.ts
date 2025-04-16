import { AmplifyBackend, BackendOutput } from '@aws-amplify/backend';
import { auth } from './auth/resource';
import { storage } from './storage/resource';

const backend = new AmplifyBackend({
  auth,
  storage,
});

// Export the backend
export default backend;

// Export outputs for frontend consumption
export type AmplifyBackendOutput = BackendOutput<typeof backend>;