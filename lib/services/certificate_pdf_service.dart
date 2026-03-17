import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/certificate_model.dart';

class CertificatePdfService {
  static Future<File> generateAndSave(CertificateModel cert) async {
    final pdf = await _buildPdf(cert);
    final dir = await getApplicationDocumentsDirectory();
    final name = 'BrainCred_Certificate_${cert.id}.pdf';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> shareOrPrint(CertificateModel cert) async {
    final pdf = await _buildPdf(cert);
    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: 'Certificate_${cert.courseTitle}_${cert.lessonTitle}.pdf',
    );
  }

  static Future<pw.Document> _buildPdf(CertificateModel cert) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('MMMM d, yyyy').format(cert.issuedAt);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 2, color: PdfColors.blue900),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Text(
                  'BRAIN CRED',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Knowledge to Cash',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.blue700,
                ),
              ),
              pw.SizedBox(height: 32),
              pw.Text(
                'CERTIFICATE OF ACHIEVEMENT',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Container(
                width: 200,
                height: 2,
                color: PdfColors.blue300,
              ),
              pw.SizedBox(height: 24),
              pw.Text(
                'This is to certify that',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                cert.userName,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'has successfully completed the lesson',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '"${cert.lessonTitle}"',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'from the course "${cert.courseTitle}"',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 24),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Text(
                      'Score: ${cert.scorePercent}%',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Text(
                      'Grade: ${cert.grade}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Text(
                'Date of issue: $dateStr',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'This certificate is issued by Brain Cred educational platform.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }
}
