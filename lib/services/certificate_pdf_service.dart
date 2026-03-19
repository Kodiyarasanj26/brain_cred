import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/certificate_model.dart';

class CertificatePdfService {
  static Future<Uint8List> buildPdfBytes(CertificateModel cert) async {
    final pdf = await _buildPdf(cert);
    return pdf.save();
  }

  static Future<File> generateAndSave(CertificateModel cert) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = 'BrainCred_Certificate_${cert.id}.pdf';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(await buildPdfBytes(cert));
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
    final certificateId = cert.id.length > 8 ? cert.id.substring(0, 8).toUpperCase() : cert.id.toUpperCase();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (ctx) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: PdfColors.grey400, width: 1),
            ),
            child: pw.Column(
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(8),
                      topRight: pw.Radius.circular(8),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'BRAIN CRED',
                            style: pw.TextStyle(
                              color: PdfColors.blue900,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.2,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Knowledge to Cash',
                            style: pw.TextStyle(
                              color: PdfColors.grey700,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                          border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
                        ),
                        child: pw.Text(
                          'CERT-$certificateId',
                          style: pw.TextStyle(
                            color: PdfColors.grey800,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 9,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Container(height: 1, color: PdfColors.grey300),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(42, 32, 42, 24),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'CERTIFICATE',
                          style: pw.TextStyle(
                            color: PdfColors.grey800,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 34,
                            letterSpacing: 2.0,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'OF COMPLETION',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 13,
                            letterSpacing: 2.2,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 34),
                        pw.Text(
                          'This is to certify that',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          cert.userName,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.blue900,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Container(width: 300, height: 1, color: PdfColors.grey300),
                        pw.SizedBox(height: 18),
                        pw.Text(
                          'has successfully completed the lesson',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Text(
                          '"${cert.lessonTitle}"',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'Course: ${cert.courseTitle}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 13,
                          ),
                        ),
                        pw.SizedBox(height: 26),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            _metricBadge('Score', '${cert.scorePercent}%'),
                            pw.SizedBox(width: 12),
                            _metricBadge('Grade', cert.grade),
                            pw.SizedBox(width: 12),
                            _metricBadge('Issued', dateStr),
                          ],
                        ),
                        pw.Spacer(),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Expanded(
                              child: _signatureBlock(
                                label: 'Academic Director',
                                value: 'Brain Cred',
                              ),
                            ),
                            pw.SizedBox(width: 20),
                            pw.Expanded(
                              child: _signatureBlock(
                                label: 'Date',
                                value: dateStr,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 14),
                        pw.Text(
                          'Credential ID: CERT-$certificateId',
                          style: pw.TextStyle(
                            color: PdfColors.grey600,
                            fontSize: 9,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _metricBadge(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(
          color: PdfColors.grey300,
          width: 0.8,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label.toUpperCase(),
            style: pw.TextStyle(
              color: PdfColors.grey700,
              fontSize: 8,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: PdfColors.grey900,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _signatureBlock({
    required String label,
    required String value,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          height: 1,
          color: PdfColors.grey500,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: PdfColors.grey900,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          label,
          style: pw.TextStyle(
            color: PdfColors.grey700,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
