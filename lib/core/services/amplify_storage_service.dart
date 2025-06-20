import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/storage_interface.dart';

class AmplifyStorageService implements StorageInterface {
  @override
  Future<void> uploadFile(String key, File file) async {
    try {
      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(file.path),
        path: StoragePath.fromString(key),
      ).result;
    } on StorageException catch (e) {
      safePrint('Error uploading file: $e');
      rethrow;
    }
  }

  @override
  Future<void> uploadData(String key, String data) async {
    try {
      await Amplify.Storage.uploadData(
        data: StorageDataPayload.string(data),
        path: StoragePath.fromString(key),
      ).result;
    } on StorageException catch (e) {
      safePrint('Error uploading data: $e');
      rethrow;
    }
  }

  @override
  Future<String> downloadData(String key) async {
    try {
      final result = await Amplify.Storage.downloadData(
        path: StoragePath.fromString(key),
      ).result;
      return result.bytes.toString();
    } on StorageException catch (e) {
      safePrint('Error downloading data: $e');
      rethrow;
    }
  }

  @override
  Future<void> downloadFile(String key, String localPath) async {
    try {
      await Amplify.Storage.downloadFile(
        path: StoragePath.fromString(key),
        localFile: AWSFile.fromPath(localPath),
      ).result;
    } on StorageException catch (e) {
      safePrint('Error downloading file: $e');
      rethrow;
    }
  }

  @override
  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(key),
      ).result;
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint('Error getting URL: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFile(String key) async {
    try {
      await Amplify.Storage.remove(
        path: StoragePath.fromString(key),
      ).result;
    } on StorageException catch (e) {
      safePrint('Error removing file: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> listFiles(String prefix) async {
    try {
      final result = await Amplify.Storage.list(
        path: StoragePath.fromString(prefix),
      ).result;
      return result.items.map((item) => item.path).toList();
    } on StorageException catch (e) {
      safePrint('Error listing files: $e');
      return [];
    }
  }
}
