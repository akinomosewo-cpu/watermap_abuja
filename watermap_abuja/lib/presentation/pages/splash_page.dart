import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/routes/page_transitions.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth_cubit.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

/// Animated brand reveal (~1.2s) shown on launch while the persisted local
/// session is checked, then hands off to either the home screen (returning,
/// logged-in user) or the login screen.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();
  late final Animation<double> _scale =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    // Deferred to after the first frame so the BlocListener below is
    // already subscribed by the time this emits.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AuthCubit>().checkSession();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(AuthState state) {
    if (state is AuthUnknown) return;
    final page =
        state is AuthAuthenticated ? const HomePage() : const LoginPage();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(AppPageTransitions.fadeThrough(page));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _navigate(state),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(Icons.water_drop_rounded,
                          color: Colors.white, size: 52),
                    ),
                    const SizedBox(height: 20),
                    Text('WaterMap Abuja',
                        style: AppTextStyles.headlineLarge
                            .copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('Outage alerts & tanker booking',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
