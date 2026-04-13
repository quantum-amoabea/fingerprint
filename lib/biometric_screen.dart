import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

Future<void> _authenticate() async {
  try {
    final bool canAuthenticate =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication is not available on this device'),
        ),
      );
      return;
    }

    final bool isAuthenticated = await auth.authenticate(
      localizedReason: 'Please scan your fingerprint to continue',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if (!mounted) return;

    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  } catch (e) {
    debugPrint('Authentication error: $e');
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authentication error: $e'),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Login'),
      ),
      body: Center(
        child: _isAuthenticated
            ? const Text(
                'Welcome!',
                style: TextStyle(fontSize: 24),
              )
            : ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Login with Fingerprint'),
              ),
      ),
    );
  }
}