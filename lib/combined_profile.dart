import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const CombinedProfileApp());
}

class CombinedProfileApp extends StatelessWidget {
  const CombinedProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Combined Profile',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121c15),
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const CombinedProfilePage(),
    );
  }
}

class CombinedProfilePage extends StatelessWidget {
  const CombinedProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Account', icon: Icon(Icons.person)),
              Tab(text: 'Health', icon: Icon(Icons.health_and_safety)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountView(),
            HealthView(),
          ],
        ),
      ),
    );
  }
}

/// ACCOUNT (Edit Profile) VIEW
class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final TextEditingController nameController =
      TextEditingController(text: "Dr. Jonathan Smith");
  final TextEditingController emailController =
      TextEditingController(text: "j.smith@pathologylab.com");
  final TextEditingController phoneController =
      TextEditingController(text: "+1 (555) 123-4567");

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.scaffoldBackgroundColor.withOpacity(0.9),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.more_vert),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    // Profile Picture
                    Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!) as ImageProvider
                                  : const NetworkImage(
                                      "https://lh3.googleusercontent.com/aida-public/AB6AXuCRLLLOnmDoUw0_AjuXVJwXVwQ0SrR8fKoAETSJ6It6jzR93Vlo49m2powAQKqNAJr54cPUmqd3pA34C2N5L1ENuoT2yldO_o1cGh-H8kiPGK5l1Rzu75KhNKBJmAf7Raa7t8nJATfLMEMbi400LH_POhi_U8a7eioeRJYN8-yUV0ImHYu0UHoCEgw8b02qG5GhEZ56GH8WYNfwyCgcToD_BaeEdXE1fMdLkx_VO_J8GDLeD2ypJhlk9H7Wr2TGf4UgGdTkU0r7sOHO",
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.green,
                                  child: const Icon(Icons.photo_camera,
                                      color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Edit Photo",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        // ADDED: thin separator below the photo/title
                        const Divider(thickness: 1, height: 1),
                        const SizedBox(height: 12),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Form Fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildTextField("Full Name", nameController),
                          const SizedBox(height: 12),
                          _buildTextField("Email Address", emailController,
                              keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          _buildTextField("Phone Number", phoneController,
                              keyboardType: TextInputType.phone),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ADDED: separator between form and change-password section
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),
                    // Change Password Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.scaffoldBackgroundColor,
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // Placeholder
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Change password')),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.greenAccent,
                                  child: Icon(Icons.lock_reset, color: Colors.green),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Change Password",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Icon(Icons.chevron_right, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ADDED: separator before the bottom spacer/save area
                    const Divider(thickness: 1),
                    const SizedBox(height: 100), // Spacer for Save Button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              // Save changes placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved')),
              );
            },
            child: const Text(
              "Save Changes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// HEALTH (User Health Profile) VIEW
class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  String? gender;
  bool showAadhar = false;

  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final aadharCtrl = TextEditingController(text: "123456789012");
  final historyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                /// APP BAR (local)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.health_and_safety),
                      Expanded(
                        child: Text(
                          "User Health Profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                    ],
                  ),
                ),

                /// BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// PRIVACY CARD
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13EC5B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF13EC5B).withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified_user, color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Data Privacy Guaranteed",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Your medical data is encrypted and shared only with certified pathologists.",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ADDED: divider after privacy card
                        const SizedBox(height: 8),
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),

                        _title("Personal Metrics"),

                        _dropdown(
                          label: "Gender",
                          value: gender,
                          items: const [
                            DropdownMenuItem(
                              value: "male",
                              child: Text("Male"),
                            ),
                            DropdownMenuItem(
                              value: "female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem(
                              value: "other",
                              child: Text("Other"),
                            ),
                            DropdownMenuItem(
                              value: "na",
                              child: Text("Prefer not to say"),
                            ),
                          ],
                          onChanged: (v) => setState(() => gender = v),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _field(
                                  label: "Height (cm)",
                                  ctrl: heightCtrl,
                                  hint: "175",
                                  type: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _field(
                                  label: "Weight (kg)",
                                  ctrl: weightCtrl,
                                  hint: "70",
                                  type: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ADDED: separator between Personal Metrics and Identity & Privacy
                        const SizedBox(height: 8),
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),

                        _title("Identity & Privacy"),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Aadhar Card Number"),
                              const SizedBox(height: 8),
                              TextField(
                                controller: aadharCtrl,
                                keyboardType: TextInputType.number,
                                obscureText: !showAadhar,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      showAadhar
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(
                                      () => showAadhar = !showAadhar,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(Icons.lock, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    "Securely Encrypted",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ADDED: separator between Identity & Privacy and Medical History
                        const SizedBox(height: 8),
                        const Divider(thickness: 1),
                        const SizedBox(height: 8),

                        _title("Medical History"),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _field(
                            label: "Past Conditions (Optional)",
                            ctrl: historyCtrl,
                            max: 4,
                            hint: "Chronic asthma, Gluten allergy...",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM BUTTON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13EC5B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Health info updated')),
                        );
                      },
                      child: const Text(
                        "Update Health Info",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          t,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    String? hint,
    int max = 1,
    TextInputType? type,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: type,
            maxLines: max,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      );

  Widget _dropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              decoration: const InputDecoration(hintText: "Select"),
            ),
          ],
        ),
      );
}
