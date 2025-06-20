import 'dart:io';

abstract class StorageInterface {
  Future<void> uploadFile(String key, File file);
  Future<void> uploadData(String key, String data);
  Future<String> downloadData(String key);
  Future<void> downloadFile(String key, String localPath);
  Future<String> getUrl(String key);
  Future<void> removeFile(String key);
  Future<List<String>> listFiles(String prefix);
}
