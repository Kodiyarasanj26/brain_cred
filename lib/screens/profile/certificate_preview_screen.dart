import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../core/theme/app_theme.dart';
import '../../models/certificate_model.dart';
import '../../services/certificate_pdf_service.dart';

class CertificatePreviewScreen extends StatefulWidget {
  const CertificatePreviewScreen({super.key, required this.cert});

  final CertificateModel cert;

  @override
  State<CertificatePreviewScreen> createState() => _CertificatePreviewScreenState();
}

class _CertificatePreviewScreenState extends State<CertificatePreviewScreen> {
  bool _saving = false;

  Future<void> _savePdfToDevice() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await CertificatePdfService.generateAndSave(widget.cert);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Certificate saved to device'),
          backgroundColor: AppTheme.success,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (_) => CertificatePdfService.buildPdfBytes(widget.cert),
        pdfFileName: 'BrainCred_Certificate_${widget.cert.id}.pdf',
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        actions: [
          IconButton(
            tooltip: _saving ? 'Saving...' : 'Download PDF',
            onPressed: _saving ? null : _savePdfToDevice,
            icon: const Icon(Icons.download_rounded),
          ),
        ],
        useActions: true,
      ),
    );
  }
}

