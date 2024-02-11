import 'package:flutter/material.dart';
import 'package:my_pa/screens/app_info_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  Future<void> _launchUrl(BuildContext context) async {
    final Uri _url = Uri.parse(
        'https://docs.google.com/document/d/15q8jlkIDC-1PWnVAFmO2U7dxtscTLCjT/edit?usp=sharing&ouid=106533545059119776058&rtpof=true&sd=true');
    if (!await launchUrl(_url)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(8),
              onTap: () {
                _launchUrl(context);
              },
              leading: Icon(Icons.article),
              title: Text("Privacy Policy Statement"),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(8),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppInfoScreen(),
                  ),
                );
              },
              leading: Icon(Icons.info),
              title: Text("App info"),
            ),
          ],
        ),
      ),
    );
  }
}
