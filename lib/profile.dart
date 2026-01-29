import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13EC5B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFE9F9EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
        ),
      ),
      home: const CompleteProfilePage(),
    );
  }
}

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final picker = ImagePicker();
  File? profileImage;

  final nameCtrl = TextEditingController(text: "Dr. Jonathan Smith");
  final emailCtrl = TextEditingController(text: "j.smith@pathologylab.com");
  final phoneCtrl = TextEditingController(text: "+1 (555) 123-4567");

  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final aadharCtrl = TextEditingController(text: "123456789012");
  final historyCtrl = TextEditingController();

  String? gender;
  bool showAadhar = false;

  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => profileImage = File(img.path));
  }

  void changePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Old Password"),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Password updated")));
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF13EC5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Health Info"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROFILE CARD
            _card(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: primaryGreen.withOpacity(.2),
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person, size: 55)
                            : null,
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: primaryGreen,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18),
                          onPressed: pickImage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field("Full Name", nameCtrl),
                  _field("Email", emailCtrl),
                  _field("Phone", phoneCtrl),
                  const SizedBox(height: 12),
                  // removed inline Change Password button from here for cleaner profile card
                ],
              ),
            ),

            const SizedBox(height: 12),

            // NEW: Separate small card for Change Password (better visual placement)
            _card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                leading: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF13EC5B),
                  child: Icon(Icons.lock_reset, color: Colors.black, size: 18),
                ),
                title: const Text(
                  "Change Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Tap to update your account password"),
                trailing: const Icon(Icons.chevron_right),
                onTap: changePasswordDialog,
              ),
            ),

            const SizedBox(height: 16),

            /// HEALTH CARD
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Privacy / assurance card
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13EC5B).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF13EC5B).withOpacity(0.15)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified_user, color: Colors.green),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Data Privacy Guaranteed — your medical data is encrypted and shared only with certified pathologists.",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Personal Metrics
                  _sectionTitle("Personal Metrics"),
                  DropdownButtonFormField<String>(
                    value: gender,
                    hint: const Text("Select Gender"),
                    items: const [
                      DropdownMenuItem(value: "male", child: Text("Male")),
                      DropdownMenuItem(value: "female", child: Text("Female")),
                      DropdownMenuItem(value: "other", child: Text("Other")),
                      DropdownMenuItem(value: "na", child: Text("Prefer not to say")),
                    ],
                    onChanged: (v) => setState(() => gender = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _field("Height (cm)", heightCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _field("Weight (kg)", weightCtrl)),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),

                  // Identity & Privacy
                  _sectionTitle("Identity & Privacy"),
                  _field(
                    "Aadhar Number",
                    aadharCtrl,
                    obscure: !showAadhar,
                    suffix: IconButton(
                      icon: Icon(showAadhar ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => showAadhar = !showAadhar),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.lock, size: 14),
                      SizedBox(width: 6),
                      Text("Securely Encrypted", style: TextStyle(fontSize: 12)),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),

                  // Medical History
                  _sectionTitle("Medical History"),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _field(
                      "Past Conditions (Optional)",
                      historyCtrl,
                      max: 4,
                      hint: "Chronic asthma, Gluten allergy...",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully"),
                    ),
                  );
                },
                child: const Text(
                  "Save All Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
      ],
    ),
    child: child,
  );

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int max = 1,
    bool obscure = false,
    Widget? suffix,
    String? hint,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: ctrl,
      maxLines: max,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6F8F6),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
