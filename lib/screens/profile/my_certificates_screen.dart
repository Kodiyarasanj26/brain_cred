import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../models/certificate_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/certificate_pdf_service.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(kSimulatedShortDelay, () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Certificates'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const SafeArea(
          child: AppLoadingIndicator(message: 'Loading certificates...'),
        ),
      );
    }
    final userEmail = context.watch<AuthProvider>().currentUser?.email ?? '';
    final certs = LocalStorageService.getCertificates(userEmail);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: certs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No certificates yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pass lesson tests with 70% or more to earn certificates.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: certs.length,
                itemBuilder: (context, index) {
                  final cert = certs[index];
                  return _CertificateCard(cert: cert);
                },
              ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.cert});
  final CertificateModel cert;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(cert.issuedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: AppTheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.courseTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        cert.lessonTitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.percent_rounded, size: 16, color: AppTheme.primary),
                  label: Text('${cert.scorePercent}%'),
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(cert.grade),
                  backgroundColor: AppTheme.success.withValues(alpha: 0.15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await CertificatePdfService.generateAndSave(cert);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Certificate saved to device'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.download_rounded, size: 20),
                label: const Text('Download PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
