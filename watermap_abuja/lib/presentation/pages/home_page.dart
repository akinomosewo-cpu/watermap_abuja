import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/routes/page_transitions.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/tanker_bloc.dart';
import '../blocs/water_bloc.dart';
import 'auth/login_page.dart';
import 'order_history_page.dart';
import 'outage_list_page.dart';

/// Root shell hosting the three main tabs: outage map, tankers/orders, and
/// order history. Tanker booking itself is reached from a district's detail
/// page so the user always books in the context of a specific area.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static final _pages = [
    const OutageListPage(),
    const OrderHistoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<WaterBloc>().add(const WaterStarted());
    context.read<TankerBloc>().add(const TankerStarted());
  }

  void _logOut() async {
    await context.read<AuthCubit>().logOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      AppPageTransitions.fadeThrough(const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _pages),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: IconButton(
                  tooltip: 'Log out',
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.textSecondary),
                  onPressed: _logOut,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.water_drop_outlined),
                  selectedIcon: Icon(Icons.water_drop_rounded),
                  label: 'Water Map'),
              NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders'),
            ],
          ),
        ),
      ),
    );
  }
}
