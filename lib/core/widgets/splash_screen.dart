import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Önce getSignedInUser() çağrı - storage'dan bilgileri yükle
    //await ref.read(authNotifierProvider.notifier).getSignedInUser();

    if (!mounted) return;

    // Biraz bekleme süresi ekle (loading görseli göstersin diye)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Token kontrol et
    //final authState = ref.read(authNotifierProvider);

    //authState.userToken.fold(
    // Token yoksa giriş sayfasına git
    // () {
    //   router.go('/sign-in');
    // },
    // Token varsa anasayfaya git
    //   (token) {
    //     router.go('/home');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/daphne_transparent.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 32),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            // Optional: Loading Text
            Text(
              'Yeşeriyor...',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
