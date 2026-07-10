import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/extensions.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = ref.read(authRepositoryProvider);
    try {
      if (_isSignUp) {
        await auth.signUpWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text, displayName: _nameCtrl.text.trim());
      } else {
        await auth.signInWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
      }
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authRepositoryProvider);

    if (!auth.isConfigured) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 48, color: context.colors.onSurfaceVariant),
                const SizedBox(height: 16),
                Text('Sign-in isn\'t set up yet', style: context.textStyles.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'This build hasn\'t been connected to a Firebase project. Everything else — saved '
                  'programs, reminders, documents and tracking — already works fully offline without '
                  'an account.',
                  style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Create account' : 'Sign in')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding()),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              if (_isSignUp) ...[
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: context.colors.error)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isSignUp ? 'Create account' : 'Sign in'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(_isSignUp ? 'Already have an account? Sign in' : 'New here? Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
