import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/feature/auth/application/providers/auth_providers.dart';
import 'package:chat_app/feature/auth/application/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginWithEmail extends ConsumerStatefulWidget {
  const LoginWithEmail({super.key});
  @override
  ConsumerState<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends ConsumerState<LoginWithEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final local = AppLocalizations.of(context);
    await ref.read(authNotifierProvider.notifier).sendOtp(email);

    final authState = ref.read(authNotifierProvider);
    if (authState.status == AuthStatus.success && mounted) {
      context.go('/verification', extra: email);
    } else if (authState.status == AuthStatus.error && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authState.errorMessage ?? local!.t('loginUnknownError'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final local = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    'assets/images/daphne_color_icon.png',
                    width: 160,
                    height: 160,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    local!.t('loginTitle'),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: local.t('loginEmailAddress'),
                            filled: true,
                            fillColor: colors.inputBackground,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email) {
                            // Save it
                          },
                        ),
                        const SizedBox(height: 16.0),

                        ElevatedButton(
                          onPressed: isLoading ? null : _sendOtp,

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: colors.primaryButton,
                            foregroundColor: colors.buttonText,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(local.t('loginSendCode')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
