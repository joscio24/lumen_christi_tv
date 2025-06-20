import 'dart:convert';

import 'package:flutter/material.dart';


class NousRejoindre extends StatefulWidget {
  const NousRejoindre({super.key});

  @override
  State<NousRejoindre> createState() => _NousRejoindreState();
}

class _NousRejoindreState extends State<NousRejoindre> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Future<void> submitProfile() async {
//   final url = Uri.parse("https://lumenchristitv.com/wp-json/custom/v1/submit-profile");

//   final response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "name": nameController.text,
//       "dob": dobController.text,
//       "email": emailController.text,
//       "contact": contactController.text,
//       "city": cityController.text,
//     }),
//   );

//   if (response.statusCode == 200) {
//     print("Profile saved successfully!");
//   } else {
//     print("Failed to save profile: ${response.body}");
//   }
// }
