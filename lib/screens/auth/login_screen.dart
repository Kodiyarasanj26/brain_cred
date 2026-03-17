import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.fromSignup = false});
  final bool fromSignup;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.fromSignup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Account created! Please sign in.'),
              backgroundColor: AppTheme.primary,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() => _isLoading = false);
      return;
    }
    await Future.delayed(kSimulatedApiDelay);
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    await Future.delayed(kSimulatedShortDelay);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      context.go('/home');
    } else {
      setState(() => _errorMessage = 'Invalid email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Icon(
                  Icons.psychology_rounded,
                  size: 64,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue to ${AppConstants.appName}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppTheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: FormValidators.email,
                  onChanged: (_) {
                    if (_errorMessage != null) setState(() => _errorMessage = null);
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: FormValidators.password,
                  onChanged: (_) {
                    if (_errorMessage != null) setState(() => _errorMessage = null);
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _submit,
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
                      : const Text('Sign In'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
