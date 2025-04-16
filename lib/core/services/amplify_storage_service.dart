import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/storage_interface.dart';
import 'package:path/path.dart' as p;

class AmplifyStorageService implements StorageInterface {
  @override
  Future<void> uploadFile(String key, File file) async {
    try {
      final options = StorageUploadFileOptions(
        pluginOptions: S3UploadFilePluginOptions(
          accessLevel: StorageAccessLevel.private,
          metadata: {
            'contentType': _getContentType(p.extension(file.path)),
          },
        ),
      );

      await Amplify.Storage.uploadFile(
        localFile: file,
        key: key,
        options: options,
      ).result;
    } catch (e, stackTrace) {
      LoggerService.error('Failed to upload file', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> uploadData(String key, Uint8List data) async {
    try {
      final options = StorageUploadDataOptions(
        pluginOptions: S3UploadDataPluginOptions(
          accessLevel: StorageAccessLevel.private,
          metadata: {
            'contentType': 'application/octet-stream',
          },
        ),
      );

      await Amplify.Storage.uploadData(
        data: data,
        key: key,
        options: options,
      ).result;
    } catch (e, stackTrace) {
      LoggerService.error('Failed to upload data', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<File> downloadFile(String key, String localPath) async {
    try {
      final options = StorageDownloadFileOptions(
        pluginOptions: S3DownloadFilePluginOptions(
          accessLevel: StorageAccessLevel.private,
        ),
      );

      final result = await Amplify.Storage.downloadFile(
        key: key,
        localFile: File(localPath),
        options: options,
      ).result;

      return result.file;
    } catch (e, stackTrace) {
      LoggerService.error('Failed to download file', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> getUrl(String key) async {
    try {
      final options = StorageGetUrlOptions(
        pluginOptions: S3GetUrlPluginOptions(
          accessLevel: StorageAccessLevel.private,
          expires: const Duration(hours: 1),
        ),
      );

      final result = await Amplify.Storage.getUrl(
        key: key,
        options: options,
      ).result;

      return result.url.toString();
    } catch (e, stackTrace) {
      LoggerService.error('Failed to get URL', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> removeFile(String key) async {
    try {
      final options = StorageRemoveOptions(
        pluginOptions: S3RemovePluginOptions(
          accessLevel: StorageAccessLevel.private,
        ),
      );

      await Amplify.Storage.remove(
        key: key,
        options: options,
      ).result;
    } catch (e, stackTrace) {
      LoggerService.error('Failed to remove file', e, stackTrace);
      rethrow;
    }
  }

  @override
  String generateUserImageKey(String userId, String type) {
    return 'users/$userId/images/$type/${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  String generateArticleKey(String authorId, String articleId) {
    return 'articles/$authorId/$articleId/content.md';
  }

  @override
  String generateArticleImageKey(
      String authorId, String articleId, String fileName) {
    return 'articles/$authorId/$articleId/images/$fileName';
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.md':
        return 'text/markdown';
      default:
        return 'application/octet-stream';
    }
  }
}
