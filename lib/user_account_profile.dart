import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Map<String, dynamic>? config;
  final Map<String, TextEditingController> controllers = {};
  File? _profileImage;
  final picker = ImagePicker();
  final Color greenColor = const Color(0xFF13EC5B);

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final data = await rootBundle.loadString('assets/user_account_profile.json');
    final decoded = json.decode(data);

    for (var field in decoded['fields']) {
      controllers[field['key']] = TextEditingController(text: field['value']);
    }

    setState(() => config = decoded);
  }

  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _profileImage = File(img.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          config!['title'],
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        // 🔹 Back Arrow on Left Side
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back action
          },
        ),

    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : NetworkImage(config!['profile']['default_image'])
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: greenColor,
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              config!['profile']['edit_text'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            /// 🔹 Dynamic Fields from JSON
            ...config!['fields'].map<Widget>((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: buildField(f),
              );
            }).toList(),

            const SizedBox(height: 24),

            /// 🔹 Change Password (Bigger Box)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: greenColor, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: greenColor.withOpacity(0.2),
                          child: Icon(Icons.lock_reset, color: greenColor),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          config!['buttons']['change_password'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: greenColor),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right, color: greenColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // ✅ Small round rectangle
              ),
            ),
            onPressed: () {},
            child: Text(
              config!['buttons']['save'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(Map field) {
    TextInputType type = TextInputType.text;
    if (field['keyboard'] == 'email') type = TextInputType.emailAddress;
    if (field['keyboard'] == 'phone') type = TextInputType.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field['label'].toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controllers[field['key']],
          keyboardType: type,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: greenColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: greenColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
