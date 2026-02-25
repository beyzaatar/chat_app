import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

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
                    "Giriş Yap",
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
                          decoration: InputDecoration(
                            hintText: 'Telefon Numarası',
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
                          keyboardType: TextInputType.phone,
                          onSaved: (phone) {
                            // Save it
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Şifre',
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
                            onSaved: (password) {
                              // Save it
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Navigate to the main screen
                            }
                            context.go('/entry-point');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: colors.primaryButton,
                            foregroundColor: colors.buttonText,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Giriş Yap"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          child: Text(
                            'Şifremi Unuttum?',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withValues(alpha: 0.64),
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/sign-up'),
                          child: Text.rich(
                            TextSpan(
                              text: "Hesabınız yok mu? ",
                              children: [
                                TextSpan(
                                  text: "Kayıt Ol",
                                  style: TextStyle(
                                    color: colors.secondaryButton,
                                  ),
                                ),
                              ],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withValues(alpha: 0.64),
                                ),
                          ),
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
