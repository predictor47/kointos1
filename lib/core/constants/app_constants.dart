class AppConstants {
  // API URLs
  static const apiBaseUrl =
      'https://api.kointos.com/v1'; // Replace with actual API URL
  static const coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  // Storage paths
  static const userProfileImagesPath = 'users/{userId}/images';
  static const articleImagesPath = 'articles/{articleId}/images';
  static const postImagesPath = 'posts/{postId}/images';

  // Cache keys
  static const cryptoCacheKey = 'crypto_cache';
  static const marketDataCacheKey = 'market_data_cache';
  static const userProfileCacheKey = 'user_profile_cache';
  static const articleCacheKey = 'article_cache';

  // Cache durations
  static const cryptoCacheDuration = Duration(minutes: 5);
  static const marketDataCacheDuration = Duration(minutes: 5);
  static const userProfileCacheDuration = Duration(hours: 1);
  static const articleCacheDuration = Duration(hours: 24);

  // Pagination
  static const defaultPageSize = 20;
  static const maxPageSize = 100;

  // Image sizes and limits
  static const maxImageSize = 5 * 1024 * 1024; // 5MB
  static const maxImageDimension = 2048;
  static const thumbnailSize = 200;
  static const profileImageSize = 400;
  static const postImageSize = 800;
  static const maxImagesPerPost = 4;
  static const maxImagesPerArticle = 10;

  // String lengths
  static const maxTitleLength = 100;
  static const maxSummaryLength = 200;
  static const maxContentLength = 50000;
  static const maxTagLength = 30;
  static const maxTagsCount = 5;

  // Timeouts
  static const apiTimeout = Duration(seconds: 30);
  static const uploadTimeout = Duration(minutes: 5);
  static const downloadTimeout = Duration(minutes: 5);
  static const socketTimeout = Duration(seconds: 30);

  // Auth
  static const passwordMinLength = 8;
  static const passwordMaxLength = 128;
  static const usernameMinLength = 3;
  static const usernameMaxLength = 30;
  static const sessionTimeout = Duration(days: 7);

  // Rate limits
  static const maxRequestsPerMinute = 60;
  static const maxUploadsPerDay = 100;
  static const maxPostsPerDay = 50;
  static const maxCommentsPerDay = 200;
}
