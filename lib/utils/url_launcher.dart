import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  UrlLauncher();

  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Errore al lancio di: $url';
    }
  }
}
