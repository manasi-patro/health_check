import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'pdf_service.dart';

class TestReportScreen extends StatefulWidget {
  const TestReportScreen({super.key});

  @override
  State<TestReportScreen> createState() => _TestReportScreenState();
}

class _TestReportScreenState extends State<TestReportScreen> {
  Map<String, dynamic>? data;

  static const primaryGreen = Color(0xFF13EC5B);
  static const darkText = Color(0xFF0D1B12);
  static const mutedGreen = Color(0xFF4C9A66);
  static const borderLight = Color(0xFFcfe7d7);

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String response =
    await rootBundle.loadString('assets/test_report_screen.json');
    setState(() {
      data = json.decode(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lab = data!['lab'];
    final patient = data!['patient'];
    final sections = data!['sections'] as List;
    final doctorNote = data!['doctor_note'];
    final disclaimer = data!['disclaimer'];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.9),
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Test Report",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.ios_share, color: Colors.black),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 0.6,
            color: primaryGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labHeader(lab),
            _patientInfo(patient),
            ...sections.map((s) => _section(s)).toList(),
            _doctorNote(doctorNote),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                disclaimer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: mutedGreen,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: borderLight)),
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: darkText,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            await PdfService.generateTestReportPdf();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Report downloaded successfully"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text(
            "Download Report (PDF)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _labHeader(Map lab) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderLight),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(lab['image']),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lab['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(lab['address'], style: const TextStyle(fontSize: 12, color: mutedGreen)),
              const SizedBox(height: 4),
              Text("ACCREDITED: ${lab['accredited']}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: mutedGreen)),
            ],
          )
        ],
      ),
    );
  }

  Widget _patientInfo(Map patient) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: Column(
        children: [
          _infoRow("Patient Name", patient['name'], "Collection Date", patient['collection_date']),
          const Divider(height: 1, thickness: 0.8, color: primaryGreen, indent: 12, endIndent: 12),
          _infoRow("Age / Gender", "${patient['age']} / ${patient['gender']}", "Report ID", patient['report_id']),
        ],
      ),
    );
  }

  Widget _section(Map section) {
    final tests = section['tests'] as List;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(section['status'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderLight),
            ),
            child: Column(
              children: [
                _tableHeader(),
                ...tests.map((t) {
                  if (t['type'] == 'normal') {
                    return _normalRow(t);
                  } else {
                    return _abnormalRow(t);
                  }
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorNote(Map note) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryGreen.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: primaryGreen),
                const SizedBox(width: 8),
                Text(note['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(note['note'], style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note['doctor_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(note['doctor_degree'], style: const TextStyle(fontSize: 11, color: mutedGreen)),
                  ],
                ),
                const Spacer(),
                Opacity(
                  opacity: 0.7,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    child: Container(
                      width: 64,
                      height: 32,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(note['signature']),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HELPER METHODS ----------------

  Widget _infoRow(String l1, String v1, String l2, String v2) {
    return Row(children: [_infoCell(l1, v1), _infoCell(l2, v2)]);
  }

  Widget _infoCell(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedGreen)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: borderLight))),
      child: const Row(
        children: [
          Expanded(flex: 6, child: Text("TEST NAME", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedGreen))),
          Expanded(flex: 3, child: Text("RESULT", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedGreen))),
          Expanded(flex: 3, child: Text("REFERENCE", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mutedGreen))),
        ],
      ),
    );
  }

  Widget _normalRow(Map t) {
    return _baseRow(t, Colors.transparent, const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _abnormalRow(Map t) {
    return _baseRow(t, Colors.red.withOpacity(0.05), const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontStyle: FontStyle.italic), icon: t['icon']);
  }

  Widget _baseRow(Map t, Color bgColor, TextStyle resultStyle, {String? icon}) {
    IconData? iconData;
    if (icon == "error") iconData = Icons.error;
    if (icon == "warning") iconData = Icons.warning;

    return Container(
      padding: const EdgeInsets.all(12),
      color: bgColor,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (iconData != null) Icon(iconData, size: 14, color: Colors.red),
                    if (iconData != null) const SizedBox(width: 4),
                    Text(t['method'], style: TextStyle(fontSize: 11, color: iconData != null ? Colors.red : mutedGreen, fontWeight: iconData != null ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: Text(t['result'], textAlign: TextAlign.right, style: resultStyle)),
          Expanded(flex: 3, child: Text(t['reference'], textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: mutedGreen))),
        ],
      ),
    );
  }
}
