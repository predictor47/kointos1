import 'package:flutter/material.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/app_theme.dart';

enum AuthMode { signIn, signUp, verification }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = getService<AuthService>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthMode _mode = AuthMode.signIn;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Navigator will handle this in parent widget
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _mode = AuthMode.verification;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _handleVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.confirmSignUp(
        _emailController.text.trim(),
        _confirmationCodeController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _mode = AuthMode.signIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.resendConfirmationCode(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code resent')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                const Text(
                  'Kointos',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Form Fields
                ..._buildFormFields(),
                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.negativeChangeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                // Action Button
                if (!_isLoading)
                  ElevatedButton(
                    onPressed: _mode == AuthMode.verification
                        ? _handleVerification
                        : _mode == AuthMode.signUp
                            ? _handleSignUp
                            : _handleSignIn,
                    child: Text(_mode == AuthMode.verification
                        ? 'Verify'
                        : _mode == AuthMode.signUp
                            ? 'Sign Up'
                            : 'Sign In'),
                  )
                else
                  const Center(child: CircularProgressIndicator()),

                // Toggle Mode Button
                if (_mode != AuthMode.verification)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _mode = _mode == AuthMode.signIn
                            ? AuthMode.signUp
                            : AuthMode.signIn;
                        _errorMessage = null;
                      });
                    },
                    child: Text(_mode == AuthMode.signIn
                        ? 'Create an account'
                        : 'Already have an account?'),
                  ),

                // Resend Code Button
                if (_mode == AuthMode.verification)
                  TextButton(
                    onPressed: _resendCode,
                    child: const Text('Resend code'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fields = <Widget>[];

    // Email Field
    fields.add(
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
    );

    fields.add(const SizedBox(height: 16));

    // Name Field (Sign Up only)
    if (_mode == AuthMode.signUp) {
      fields.add(
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Password Field (Sign In and Sign Up only)
    if (_mode != AuthMode.verification) {
      fields.add(
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (_mode == AuthMode.signUp && value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Verification Code Field
    if (_mode == AuthMode.verification) {
      fields.add(
        TextFormField(
          controller: _confirmationCodeController,
          decoration: const InputDecoration(
            labelText: 'Verification Code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the verification code';
            }
            return null;
          },
        ),
      );
    }

    return fields;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }
}
