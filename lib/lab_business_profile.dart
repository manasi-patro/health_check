import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';


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

  // Controllers
  final labName = TextEditingController(text: "City Path Labs");
  final license = TextEditingController(text: "LAB-9920-X");
  final email = TextEditingController(text: "admin@citypath.com");
  final phone = TextEditingController(text: "+1 234 567 890");
  final address = TextEditingController(
    text:
    "123 Medical Plaza, Suite 400, Downtown Health District, New York, NY 10001",
  );

  List<PlatformFile> uploadedFiles = [];

  // FILE PICKER (WEB + MOBILE)
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

  // SAVE PROFILE
  void saveProfile() {
    if (labName.text.isEmpty ||
        license.text.isEmpty ||
        email.text.isEmpty) {
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
              input("Business Email", email, suffix: Icons.check_circle_outline),
              input("Phone Number", phone),

              section("Location"),
              textarea("Full Address", address),

              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // 🔹 full rounded corners
                  child: Stack(
                    children: [
                      // 🔹 Image
                      Image.network(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDPOAdq0gjrs7msDhDeUa8QRJ1QjNA_TcTMP0diPaGZy-bWwE_-gMfXLZC91QlXYxf9lzUKKbvEZho3XR36P1Tll21ZEs1DNJx9FlVdOjiasPl8jR0benONbkDA8MJ9RNW3UTlqh-sHLGdwnoNqkE6IGEMy-BSh0F2lca-wrXihxjgmCF4NnbZAqmhcIg8E04bZAnUkzGjmXBZium4p3Y0fnX2OgQankxH-7AT7kSsfJJdnrvSHsCdeooClflbgM_hj6M_5j1917Y6-",
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      // 🔹 Semi-transparent overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1), // bg-black/10
                            borderRadius: BorderRadius.circular(16), // 🔹 overlay corners
                          ),
                        ),
                      ),

                      // 🔹 Adjust Pin button (bottom-right)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // bg-white
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // 🔹 pill button
                            ),
                            elevation: 6, // shadow
                          ),
                          onPressed: () {
                            debugPrint("Adjust Pin clicked");
                          },
                          icon: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF13EC5B), // primary color
                            size: 20,
                          ),
                          label: const Text(
                            "Adjust Pin",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //🔹 Verification & Licenses Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Verification & Licenses",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "2/3 Uploaded",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // ✅ changed to black
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// 🔹 Upload Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.05), // background light green
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primary, // green border
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.2), // circle bg
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.upload_file,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Upload New Certification",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "PDF, JPG or PNG (Max 10MB)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Browse Files",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),



              uploadedFileCard(
                fileIcon: Icons.picture_as_pdf_outlined,
                fileIconColor: Colors.red,
                fileName: "NABL_Cert_2024.pdf",
                statusText: "Verified • 1.2 MB",
                statusIcon: Icons.check_circle_outline,
                statusColor: Colors.green,
              ),

              uploadedFileCard(
                fileIcon: Icons.image_outlined,
                fileIconColor: Colors.blue,
                fileName: "Medical_License.jpg",
                statusText: "Pending Review • 3.5 MB",
                statusIcon: Icons.schedule,
                statusColor: Colors.orange,
              ),

              verificationInfoBox(),


              ...uploadedFiles.map(
                    (file) => ListTile(
                  leading: Icon(
                    file.extension == 'pdf'
                        ? Icons.picture_as_pdf
                        : Icons.image,
                    color: file.extension == 'pdf'
                        ? Colors.red
                        : Colors.blue,
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

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget input(String label, TextEditingController c,
      {IconData? suffix}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 6),
            TextField(
              controller: c,
              decoration: InputDecoration(
                suffixIcon:
                suffix != null ? Icon(suffix, color: primary) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
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
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}