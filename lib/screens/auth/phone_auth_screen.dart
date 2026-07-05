import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController(); // format: +23566xxxxxx
  final _codeController = TextEditingController();

  bool _codeSent = false;
  bool _loading = false;
  String? _error;

  Future<void> _sendCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await context.read<AuthService>().sendPhoneCode(
          phoneNumber: _phoneController.text.trim(),
          onCodeSent: () {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _codeSent = true;
            });
          },
          onError: (err) {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _error = err;
            });
          },
        );
  }

  Future<void> _confirmCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final error = await context.read<AuthService>().confirmPhoneCode(
          smsCode: _codeController.text.trim(),
          fullName: _nameController.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
    });
    if (error == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          if (!_codeSent) ...[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: t.fullName),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Numéro (ex: +23566123456)',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _sendCode,
              child: _loading
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Recevoir le code par SMS'),
            ),
          ] else ...[
            Text('Code envoyé au ${_phoneController.text}'),
            const SizedBox(height: 14),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Code reçu par SMS'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _confirmCode,
              child: _loading
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Valider le code'),
            ),
            TextButton(
              onPressed: _loading ? null : () => setState(() => _codeSent = false),
              child: const Text('Modifier le numéro'),
            ),
          ],
        ],
      ),
    );
  }
}
