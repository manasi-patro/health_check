import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile',
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
      home: const EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
            // Top AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.scaffoldBackgroundColor.withOpacity(0.9),
              child: Row(
                children: [
                  const SizedBox(width: 24), // 👈 left empty space

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

                  // 👉 RIGHT SIDE ARROW
                  GestureDetector(
                    onTap: () {
                      // Navigation to UserHealthProfile has been disabled.
                      // If you want a different behavior, replace this with:
                      // Navigator.pop(context);
                      // or show a message:
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Disabled'))
                      // );
                    },
                    child: const Icon(Icons.arrow_forward_ios, size: 24),
                  ),
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
                          // TODO: Add change password functionality
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
              // TODO: Add save changes functionality
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
