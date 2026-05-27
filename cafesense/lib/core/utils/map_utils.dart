import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class MapUtils {
  MapUtils._();

  static Future<void> navigateTo(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    final Uri appleMapsUrl = Uri.parse("https://maps.apple.com/?daddr=$lat,$lng&dirflg=d");
    final Uri browserUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");

    try {
      if (Platform.isAndroid) {
        if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isIOS) {
        if (await canLaunchUrl(appleMapsUrl)) {
          await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
        }
      } else {
        await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
    }
  }
}
