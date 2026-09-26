import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/tanker_bloc.dart';
import '../blocs/water_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.water_drop_outlined), selectedIcon: Icon(Icons.water_drop_rounded), label: 'Water Map'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
        ],
      ),
    );
  }
}
