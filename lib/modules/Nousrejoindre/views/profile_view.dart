import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  List profiles = [];

  @override
  void initState() {
    super.initState();

    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    final url = Uri.parse(
      "https://lumenchristitv.com/wp-json/custom/v1/get-profiles",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        profiles = data;
      });

      print(profiles);
    } else {
      print("Failed to load profiles");
    }
  }

  Widget buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
          
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
      ),
    );
  }

  Future<void> submitProfile() async {
    final url = Uri.parse(
      "https://lumenchristitv.com/wp-json/custom/v1/submit-profile",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "dob": dobController.text,
        "email": emailController.text,
        "contact": contactController.text,
        "city": cityController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("Profile saved successfully!");
    } else {
      print("Failed to save profile: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField("Nom et Prénom", nameController),
              buildDatePickerField("Date de naissance", dobController),
              buildInputField("Mail", emailController),
              buildInputField("Contact", contactController),
              buildInputField("Ville de résidence", cityController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isEditing ? () => submitForm() : null,
                child: Text("Soumettre"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,
        child: FloatingActionButton(
          onPressed: () => Get.toNamed('/add'),
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Soutenir",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          enabled: isEditing,
        ),
        enabled: isEditing,
      ),
    );
  }

  void submitForm() {
    // Handle form submission
    print("Form submitted with:");
    print("Nom et Prénom: ${nameController.text}");
    print("Date de naissance: ${dobController.text}");
    print("Mail: ${emailController.text}");
    print("Contact: ${contactController.text}");
    print("Ville de résidence: ${cityController.text}");
  }
}
