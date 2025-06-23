import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NousRejoindre extends StatefulWidget {
  const NousRejoindre({super.key});

  @override
  State<NousRejoindre> createState() => _NousRejoindreState();
}

class _NousRejoindreState extends State<NousRejoindre> {
  final String donationUrl =
      'https://me.fedapay.com/lumenchristitv'; // replace with real link

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(donationUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir $donationUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(child: Image.asset('assets/images/faire_don_2.png')),
          ),

          SizedBox(height: 20),

          Center(
            child: Text(
              "Aidez les orphelins et les moins privilégiés",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                "Chaque don que vous faites contribue à offrir de la nourriture, des vêtements, et un meilleur avenir aux enfants dans le besoin. Rejoignez-nous dans cette mission humanitaire.",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
          ),
          
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: _launchURL,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Faire un Don Maintenant',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
