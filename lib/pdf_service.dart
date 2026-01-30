import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateTestReportPdf() async {
    final jsonString = await rootBundle.loadString('assets/pdf_service.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Center(
                child: pw.Text(
                  data['title'],
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              // Header
              pw.Text(data['clinic']['name'], style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(data['clinic']['address']),
              pw.Text("ACCREDITED: ${data['clinic']['accreditation']}"),
              pw.SizedBox(height: 16),

              // Patient Info
              _infoRow("Patient Name", data['patient']['name']),
              _infoRow("Age / Gender", "${data['patient']['age']} / ${data['patient']['gender']}"),
              _infoRow("Collection Date", data['patient']['collection_date']),
              _infoRow("Report ID", data['patient']['report_id']),

              pw.Divider(height: 24),

              // Tests Table
              pw.Text("Metabolic Panel", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              _tableHeader(),
              ...data['tests'].map<pw.Widget>((t) => _tableRow(
                t['name'],
                t['result'],
                t['reference'],
                status: t['status'],
              )),

              pw.SizedBox(height: 20),

              // Impression
              pw.Text("Pathologist's Impression", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text(data['impression']['text']),
              pw.SizedBox(height: 16),
              pw.Text(data['impression']['doctor']),
              pw.Text(data['impression']['designation']),
            ],
          );
        },
      ),
    );

    // Save PDF
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/test_report.pdf");
    await file.writeAsBytes(await pdf.save());

    // Preview / Print
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Helper: Info row
  static pw.Widget _infoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

  // Helper: Table header
  static pw.Widget _tableHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text("TEST NAME", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text("RESULT", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Expanded(child: pw.Text("REFERENCE", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );
  }

  // Helper: Table row
  static pw.Widget _tableRow(String name, String result, String reference, {String? status}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(name),
                if (status != null)
                  pw.Text(status, style: pw.TextStyle(color: PdfColors.red, fontSize: 10)),
              ],
            ),
          ),
          pw.Expanded(child: pw.Text(result, textAlign: pw.TextAlign.right)),
          pw.Expanded(child: pw.Text(reference, textAlign: pw.TextAlign.right)),
        ],
      ),
    );
  }
}
