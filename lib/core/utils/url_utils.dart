import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> launchPhone(String phone) async {
    try {
      final uri = Uri(
        scheme: 'tel',
        path: phone.replaceAll(RegExp(r'[^\d+]'), ''),
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch phone app';
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> launchMap(
    double latitude,
    double longitude, {
    String? label,
    String? query,
  }) async {
    try {
      final params = {
        'q': '$latitude,$longitude',
        if (label != null) 'label': label,
        if (query != null) 'query': query,
      };

      final uri = Uri.https('www.google.com', '/maps/search/', params);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      rethrow;
    }
  }

  static bool isValidUrl(String urlString) {
    try {
      final uri = Uri.parse(urlString);
      return uri.scheme.isNotEmpty && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static String? sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  static Future<bool> checkUrlExists(String url) async {
    try {
      final uri = Uri.parse(url);
      final client = HttpClient();
      final request = await client.headUrl(uri);
      final response = await request.close();
      client.close();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
