import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any user authenticated via an API key can "create", "read",
"update", and "delete" any "Todo" records.
=========================================================================*/
const schema = a.schema({
  // User Profile
  UserProfile: a
    .model({
      userId: a.id().required(),
      email: a.email().required(),
      username: a.string().required(),
      displayName: a.string(),
      bio: a.string(),
      profilePicture: a.url(),
      totalPortfolioValue: a.float().default(0),
      followersCount: a.integer().default(0),
      followingCount: a.integer().default(0),
      isPublic: a.boolean().default(true),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Cryptocurrency
  Cryptocurrency: a
    .model({
      symbol: a.string().required(),
      name: a.string().required(),
      currentPrice: a.float(),
      marketCap: a.float(),
      volume24h: a.float(),
      priceChange24h: a.float(),
      priceChangePercentage24h: a.float(),
      logoUrl: a.url(),
      description: a.string(),
      website: a.url(),
      lastUpdated: a.datetime(),
    })
    .authorization(allow => [allow.authenticated().to(['read']), allow.owner()]),

  // Portfolio
  Portfolio: a
    .model({
      name: a.string().required(),
      description: a.string(),
      totalValue: a.float().default(0),
      isPublic: a.boolean().default(false),
      userId: a.id().required(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Portfolio Holdings
  PortfolioHolding: a
    .model({
      portfolioId: a.id().required(),
      cryptoSymbol: a.string().required(),
      amount: a.float().required(),
      averageBuyPrice: a.float(),
      currentValue: a.float(),
      profitLoss: a.float(),
      profitLossPercentage: a.float(),
      lastUpdated: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Transactions
  Transaction: a
    .model({
      portfolioId: a.id().required(),
      cryptoSymbol: a.string().required(),
      type: a.enum(['BUY', 'SELL', 'TRANSFER_IN', 'TRANSFER_OUT']),
      amount: a.float().required(),
      price: a.float().required(),
      totalValue: a.float().required(),
      fees: a.float().default(0),
      notes: a.string(),
      transactionDate: a.datetime().required(),
      createdAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Social Posts
  Post: a
    .model({
      userId: a.id().required(),
      content: a.string().required(),
      imageUrl: a.url(),
      likesCount: a.integer().default(0),
      commentsCount: a.integer().default(0),
      sharesCount: a.integer().default(0),
      tags: a.string().array(),
      mentionedCryptos: a.string().array(),
      isPublic: a.boolean().default(true),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner(), allow.authenticated().to(['read'])]),

  // Comments
  Comment: a
    .model({
      postId: a.id().required(),
      userId: a.id().required(),
      content: a.string().required(),
      likesCount: a.integer().default(0),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner(), allow.authenticated().to(['read'])]),

  // Likes
  Like: a
    .model({
      userId: a.id().required(),
      postId: a.id(),
      commentId: a.id(),
      createdAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Follow relationships
  Follow: a
    .model({
      followerId: a.id().required(),
      followingId: a.id().required(),
      createdAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Trading Signals
  TradingSignal: a
    .model({
      userId: a.id().required(),
      cryptoSymbol: a.string().required(),
      signalType: a.enum(['BUY', 'SELL', 'HOLD']),
      targetPrice: a.float(),
      stopLoss: a.float(),
      confidence: a.integer(), // 1-100
      reasoning: a.string(),
      expiresAt: a.datetime(),
      isActive: a.boolean().default(true),
      performanceRating: a.float(),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner(), allow.authenticated().to(['read'])]),

  // Watchlist
  Watchlist: a
    .model({
      userId: a.id().required(),
      name: a.string().required(),
      cryptoSymbols: a.string().array(),
      isPublic: a.boolean().default(false),
      createdAt: a.datetime(),
      updatedAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // Price Alerts
  PriceAlert: a
    .model({
      userId: a.id().required(),
      cryptoSymbol: a.string().required(),
      alertType: a.enum(['ABOVE', 'BELOW']),
      targetPrice: a.float().required(),
      isActive: a.boolean().default(true),
      createdAt: a.datetime(),
      triggeredAt: a.datetime(),
    })
    .authorization(allow => [allow.owner()]),

  // News Articles
  NewsArticle: a
    .model({
      title: a.string().required(),
      content: a.string().required(),
      summary: a.string(),
      author: a.string(),
      sourceUrl: a.url(),
      imageUrl: a.url(),
      publishedAt: a.datetime(),
      tags: a.string().array(),
      mentionedCryptos: a.string().array(),
      sentiment: a.enum(['POSITIVE', 'NEGATIVE', 'NEUTRAL']),
      createdAt: a.datetime(),
    })
    .authorization(allow => [allow.authenticated().to(['read']), allow.owner()]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'userPool',
  },
});
