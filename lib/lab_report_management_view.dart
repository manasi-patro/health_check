import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dotted_border/dotted_border.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the combined JSON file
  final String jsonString = await rootBundle.loadString('assets/all.json');
  final Map<String, dynamic> allData = json.decode(jsonString);

  // Extract the lab report management view data
  final labData = allData['lab_report_management_view'];

  runApp(LabReportApp(labData: labData));
}

class LabReportApp extends StatelessWidget {
  final Map<String, dynamic> labData;
  const LabReportApp({super.key, required this.labData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        brightness: Brightness.light,
        primaryColor: const Color(0xFF13EC5B),
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF13EC5B),
        scaffoldBackgroundColor: const Color(0xFF102216),
      ),
      home: LabReportPage(labData: labData),
    );
  }
}

// -------------------- Rest of your LabReportPage & widgets --------------------
// You can keep the exact same implementation as before
// Nothing else changes; it will use `labData` extracted from `all.json`

class LabReportPage extends StatefulWidget {
  final Map<String, dynamic> labData;
  const LabReportPage({super.key, required this.labData});

  @override
  State<LabReportPage> createState() => _LabReportPageState();
}

class _LabReportPageState extends State<LabReportPage> {
  String selectedStatus = 'Draft';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patient = widget.labData['patient'];
    final tests = widget.labData['tests'];
    final technicianNotes = widget.labData['technicianNotes'];
    final doctor = widget.labData['doctor'];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                // Top AppBar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Report #${widget.labData['reportNumber']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.delete, color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFF13EC5B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Selector
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              _buildStatusButton('Draft', isDark),
                              _buildStatusButton('Submitted', isDark),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Patient Card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PATIENT INFORMATION',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF13EC5B),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                patient['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${patient['gender']}, ${patient['age']} years • ID: ${patient['id']}',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 14,
                                      color: isDark ? Colors.grey[400] : Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('Collected: ${patient['collectedDate']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(patient['avatar']),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: const Color(0xFF13EC5B).withAlpha(51),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Test Parameters Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Test Parameters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13EC5B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${widget.labData['tests'].length} Tests', // ✅ Dynamic count
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF13EC5B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Test Results
                Column(
                  children: [
                    for (var test in tests)
                      Column(
                        children: [
                          _TestResultItem(
                            name: test['name'],
                            reference: test['reference'],
                            value: test['value'],
                            status: test['status'],
                            icon: _mapIcon(test['icon']),
                            color: Color(_hexToInt(test['color'])),
                            valueColor: Color(_hexToInt(test['valueColor'])),
                          ),
                          Divider(color: Colors.grey.shade300, height: 1),
                        ],
                      )
                  ],
                ),

                // Technician Notes
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Technician Remarks',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? Colors.grey[900] : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                          ),
                          hintText:
                          'Enter additional clinical observations or notes here...',
                        ),
                        controller: TextEditingController(text: technicianNotes),
                      ),
                    ],
                  ),
                ),

                // Digital Signature
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      padding: EdgeInsets.zero,
                      dashPattern: const [6, 4],
                      strokeWidth: 1.5,
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade500,
                      radius: const Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900]!.withAlpha(128) : Colors.white.withAlpha(128),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('DIGITAL SIGNATURE VERIFIED',
                              style: TextStyle(
                                  fontSize: 10, letterSpacing: 2, color: Colors.grey),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 192,
                              height: 64,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(doctor['signatureImage']),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(doctor['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center),
                          Text(doctor['title'],
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Submit Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).scaffoldBackgroundColor.withAlpha(245),
                child: ElevatedButton.icon(
                  onPressed: selectedStatus == 'Submitted'
                      ? null
                      : () {
                    setState(() {
                      selectedStatus = 'Submitted';
                    });
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Report to Patient',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13EC5B),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, bool isDark) {
    bool isSelected = selectedStatus == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedStatus = label;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.grey[700] : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String name) {
    switch (name) {
      case 'biotech':
        return Icons.biotech;
      case 'warning':
        return Icons.warning_amber;
      case 'opacity':
        return Icons.opacity;
      default:
        return Icons.help_outline;
    }
  }

  int _hexToInt(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }
}

// Test Result Item remains unchanged
class _TestResultItem extends StatelessWidget {
  final String name, reference, value, status;
  final IconData icon;
  final Color color;
  final Color valueColor;

  const _TestResultItem({
    required this.name,
    required this.reference,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  Text(reference,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      )),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                    fontSize: 16,
                  )),
              Text(status, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ],
      ),
    );
  }
}
