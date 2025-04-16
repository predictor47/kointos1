import 'dart:io';

abstract class StorageInterface {
  Future<void> uploadFile(String key, File file);
  Future<void> uploadData(String key, String data);
  Future<String> downloadData(String key);
  Future<File> downloadFile(String key, String localPath);
  Future<String> getUrl(String key);
  Future<void> removeFile(String key);
  String generateUserImageKey(String userId, String type);
  String generateArticleKey(String authorId, String articleId);
  String generateArticleImageKey(
      String authorId, String articleId, String filename);
}
