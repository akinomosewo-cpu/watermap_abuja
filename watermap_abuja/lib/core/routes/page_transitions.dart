import 'package:flutter/material.dart';

/// Short, non-blocking route transitions used between the app's major
/// screens (splash -> auth -> home, login <-> signup). Kept as a couple of
/// small helpers rather than a full custom [PageRoute] subclass so existing
/// `MaterialPageRoute` navigation elsewhere in the app is untouched.
class AppPageTransitions {
  AppPageTransitions._();

  static const Duration duration = Duration(milliseconds: 320);

  /// Cross-fades combined with a subtle upward slide - used for the main
  /// splash -> auth/home handoff.
  static Route<T> fadeThrough<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Horizontal slide - used between sibling auth screens (login/signup).
  static Route<T> sharedAxisHorizontal<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
