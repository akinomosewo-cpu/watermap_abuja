import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/routes/page_transitions.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth_cubit.dart';
import '../home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    context.read<AuthCubit>().logIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context)
                .pushReplacement(AppPageTransitions.fadeThrough(const HomePage()));
          } else if (state is AuthUnauthenticated) {
            setState(() => _submitting = false);
            if (state.error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error!)));
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.water_drop_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const Gap(24),
                  Text('Welcome back',
                      style: AppTextStyles.displaySmall
                          .copyWith(color: AppColors.textPrimary)),
                  const Gap(6),
                  Text('Log in to book tankers and track outages',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  const Gap(32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const Gap(14),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Password', prefixIcon: Icon(Icons.lock_outline_rounded)),
                    validator: (v) => (v == null || v.length < 4)
                        ? 'Password must be at least 4 characters'
                        : null,
                  ),
                  const Gap(28),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Log in'),
                  ),
                  const Gap(18),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                          AppPageTransitions.sharedAxisHorizontal(
                              const SignupPage())),
                      child: Text("Don't have an account? Sign up",
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
