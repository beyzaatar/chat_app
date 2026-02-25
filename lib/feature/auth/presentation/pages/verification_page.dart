import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/feature/auth/application/providers/auth_providers.dart';
import 'package:chat_app/feature/auth/application/state/auth_state.dart';
import 'package:chat_app/feature/auth/presentation/pages/change_password_page.dart';
import 'package:chat_app/feature/auth/presentation/widgets/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationPage extends ConsumerStatefulWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends ConsumerState<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen 6 haneli kodu giriniz.')),
      );
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(widget.email, _otpCode);

    final authState = ref.read(authNotifierProvider);
    if (authState.status == AuthStatus.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.errorMessage ?? 'Geçersiz Kod')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: LogoWithTitle(
        title: 'Doğrulama',
        subText: "${widget.email} adresine\ndoğrulama kodu gönderildi",
        children: [
          Text(widget.email),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          // OTP Form
          OtpForm(
            formKey: _formKey,
            controllers: _controllers,
            isLoading: isLoading,
            onVerify: _verifyOtp,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);
