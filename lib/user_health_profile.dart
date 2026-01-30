import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const UserHealthApp());
}

class UserHealthApp extends StatelessWidget {
  const UserHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),

        /// 🔹 GLOBAL INPUT STYLE (important)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
            const BorderSide(color: Color(0xFF13EC5B), width: 1.5),
          ),
        ),
      ),
      home: const UserHealthProfile(),
    );
  }
}

class UserHealthProfile extends StatefulWidget {
  const UserHealthProfile({super.key});

  @override
  State<UserHealthProfile> createState() => _UserHealthProfileState();
}

class _UserHealthProfileState extends State<UserHealthProfile> {
  Map<String, dynamic>? config;
  final Map<String, TextEditingController> controllers = {};
  bool showAadhar = false;
  String? gender;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final data =
    await rootBundle.loadString('assets/user_health_profile.json');
    setState(() {
      config = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// APP BAR
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new),
                  Expanded(
                    child: Text(
                      config!['appBar']['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    privacyCard(),
                    ...buildSections(),
                  ],
                ),
              ),
            ),

            /// BOTTOM BUTTON
            bottomButton(),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget privacyCard() => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF13EC5B).withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.verified_user_outlined, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(config!['privacyCard']['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(config!['privacyCard']['description'],
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> buildSections() {
    return (config!['sections'] as List).map<Widget>((section) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(section['title']),
          ...buildFields(section['fields']),
        ],
      );
    }).toList();
  }

  List<Widget> buildFields(List fields) {
    return fields.map<Widget>((f) {
      switch (f['type']) {
        case 'dropdown':
          return dropdownField(f);
        case 'row':
          return rowFields(f['fields']);
        case 'aadhar':
          return aadharField(f);
        default:
          return textField(f);
      }
    }).toList();
  }

  Widget rowFields(List fields) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: fields.map<Widget>((f) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: textField(f),
          ),
        );
      }).toList(),
    ),
  );

  Widget textField(Map f) {
    controllers.putIfAbsent(f['key'], () => TextEditingController());

    // 👇 sirf medical history ke liye
    final bool isMedicalHistory = f['key'] == 'medical_history';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center( // 👈 center me aayega
        child: SizedBox(
          width: isMedicalHistory
              ? MediaQuery.of(context).size.width * 0.85 // 👈 width kam
              : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(f['label']),
              const SizedBox(height: 8),
              TextField(
                controller: controllers[f['key']],
                maxLines: f['maxLines'] ?? 1,
                keyboardType:
                f['keyboard'] == 'number' ? TextInputType.number : null,
                decoration: InputDecoration(hintText: f['hint']),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget dropdownField(Map f) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(f['label']),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: gender,
          decoration: const InputDecoration(),
          items: (f['items'] as List)
              .map<DropdownMenuItem<String>>(
                (i) => DropdownMenuItem(
              value: i['value'],
              child: Text(i['label']),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() => gender = v),
        ),
      ],
    ),
  );

  Widget aadharField(Map f) {
    controllers.putIfAbsent(f['key'], () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(f['label']),
          const SizedBox(height: 8),
          TextField(
            controller: controllers[f['key']],
            obscureText: !showAadhar,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                    showAadhar ? Icons.visibility_off : Icons.visibility),
                onPressed: () =>
                    setState(() => showAadhar = !showAadhar),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.lock, size: 12),
              const SizedBox(width: 4),
              Text(f['secureText'],
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(t,
        style:
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget bottomButton() => Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
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
        onPressed: () {},
        child: Text(
          config!['button']['text'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
