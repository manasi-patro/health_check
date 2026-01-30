import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const LabProfileApp());
}

class LabProfileApp extends StatelessWidget {
  const LabProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LabBusinessProfile(),
    );
  }
}

class LabBusinessProfile extends StatefulWidget {
  const LabBusinessProfile({super.key});

  @override
  State<LabBusinessProfile> createState() => _LabBusinessProfileState();
}

class _LabBusinessProfileState extends State<LabBusinessProfile> {
  static const Color primary = Color(0xFF13EC5B);

  Map<String, dynamic>? data;

  // Controllers
  late TextEditingController labName;
  late TextEditingController license;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController address;

  List<PlatformFile> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final jsonStr = await rootBundle.loadString("assets/lab_business_profile.json");
    final jsonData = json.decode(jsonStr);

    setState(() {
      data = jsonData;
      labName = TextEditingController(text: data!['basicInfo']['labName']);
      license = TextEditingController(text: data!['basicInfo']['license']);
      email = TextEditingController(text: data!['contactDetails']['email']);
      phone = TextEditingController(text: data!['contactDetails']['phone']);
      address = TextEditingController(text: data!['location']['address']);
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.size > 10 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${file.name} exceeds 10MB limit")),
        );
        continue;
      }

      setState(() {
        uploadedFiles.add(file);
      });
    }
  }

  void saveProfile() {
    if (labName.text.isEmpty || license.text.isEmpty || email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    debugPrint("===== LAB PROFILE DATA =====");
    debugPrint("Lab Name: ${labName.text}");
    debugPrint("License: ${license.text}");
    debugPrint("Email: ${email.text}");
    debugPrint("Phone: ${phone.text}");
    debugPrint("Address: ${address.text}");
    debugPrint("Files: ${uploadedFiles.map((e) => e.name).toList()}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Business Profile Saved Successfully")),
    );
  }

  @override
  void dispose() {
    labName.dispose();
    license.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final verification = data!['verification'];
    final location = data!['location'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Business Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.info_outline, color: primary),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              section("Basic Information"),
              input("Lab Name", labName),
              input("License Number", license),

              section("Contact Details"),
              input("Business Email", email),
              input("Phone Number", phone),

              section("Location"),
              textarea("Full Address", address),

              // 🔹 Map + Adjust Pin button (dynamic from JSON)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.network(
                        location['mapImage'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          onPressed: () {
                            debugPrint("Adjust Pin clicked");
                          },
                          icon: const Icon(
                            Icons.location_on_outlined,
                            color: primary,
                            size: 20,
                          ),
                          label: const Text(
                            "Adjust Pin",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              section("Verification & Licenses"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "${verification['uploaded']}/${verification['total']} Uploaded",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

              ...verification['files'].map<Widget>((file) {
                final icon = file['type'] == 'pdf'
                    ? Icons.picture_as_pdf
                    : Icons.image_outlined;
                final color = file['type'] == 'pdf' ? Colors.red : Colors.blue;
                return uploadedFileCard(
                  fileIcon: icon,
                  fileIconColor: color,
                  fileName: file['name'],
                  statusText:
                  "${file['status']} • ${file['sizeMB'].toString()} MB",
                  statusIcon: file['status'] == 'Verified'
                      ? Icons.check_circle_outline
                      : Icons.schedule,
                  statusColor: file['status'] == 'Verified'
                      ? Colors.green
                      : Colors.orange,
                );
              }).toList(),

              verificationInfoBox(),

              ...uploadedFiles.map(
                    (file) => ListTile(
                  leading: Icon(
                    file.extension == 'pdf'
                        ? Icons.picture_as_pdf
                        : Icons.image,
                    color: file.extension == 'pdf' ? Colors.red : Colors.blue,
                  ),
                  title: Text(file.name),
                  subtitle: Text(
                    "${(file.size / 1024 / 1024).toStringAsFixed(2)} MB",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        uploadedFiles.remove(file);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: saveProfile,
          child: const Text(
            "Save Business Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget input(String label, TextEditingController c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    ),
  );

  Widget textarea(String label, TextEditingController c) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          maxLines: 4,
          decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    ),
  );
}

Widget uploadedFileCard({
  required IconData fileIcon,
  required Color fileIconColor,
  required String fileName,
  required String statusText,
  required IconData statusIcon,
  required Color statusColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(fileIcon, color: fileIconColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusText,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          Icon(statusIcon, color: statusColor),
        ],
      ),
    ),
  );
}

Widget verificationInfoBox() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Verification increases your lab's visibility to patients by up to 40% and builds trust in the community.",
              style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    ),
  );
}
