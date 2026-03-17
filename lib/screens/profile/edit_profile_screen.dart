import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validators/form_validators.dart';
import 'dart:io';
import '../../../core/widgets/app_loading.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/profile_image_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _institutionController;
  bool _isLoading = false;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _institutionController = TextEditingController(text: user?.institutionName ?? '');
    _profileImagePath = user != null ? ProfileImageService.getProfileImagePath(user.email) : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
    if (userEmail.isEmpty) return;
    final path = await ProfileImageService.pickAndSaveProfileImage(userEmail);
    if (path != null && mounted) setState(() => _profileImagePath = path);
  }

  Future<void> _removePhoto() async {
    final userEmail = context.read<AuthProvider>().currentUser?.email ?? '';
    if (userEmail.isEmpty) return;
    await ProfileImageService.removeProfileImage(userEmail);
    if (mounted) setState(() => _profileImagePath = null);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Pick from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage();
              },
            ),
            if (_profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
                title: const Text('Remove photo', style: TextStyle(color: AppTheme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _removePhoto();
                },
              ),
            ListTile(
              leading: const Icon(Icons.close_rounded),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(kSimulatedApiDelay);
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final current = auth.currentUser!;
    final updated = current.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      institutionName: _institutionController.text.trim(),
    );
    await auth.updateProfile(updated);
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        backgroundColor: AppTheme.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
            child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                          backgroundImage: _profileImagePath != null &&
                                  File(_profileImagePath!).existsSync()
                              ? FileImage(File(_profileImagePath!))
                              : null,
                          child: _profileImagePath == null ||
                                  !File(_profileImagePath!).existsSync()
                              ? Text(
                                  (_nameController.text.isNotEmpty
                                          ? _nameController.text[0].toUpperCase()
                                          : '?'),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: FormValidators.name,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: FormValidators.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Email cannot be changed',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: FormValidators.address,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _institutionController,
                  decoration: const InputDecoration(
                    labelText: 'Institution Name',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  validator: FormValidators.institution,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primary,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
