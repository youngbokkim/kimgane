import 'package:url_launcher/url_launcher.dart';

class ExternalMapLauncher {
  static Future<bool> open(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
