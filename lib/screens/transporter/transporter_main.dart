import 'package:flutter/material.dart';
import 'transporter_dashboard.dart';
import 'available_pickups_screen.dart';
import 'my_deliveries_screen.dart';

class TransporterMainScreen extends StatefulWidget {
  const TransporterMainScreen({super.key});

  @override
  State<TransporterMainScreen> createState() => _TransporterMainScreenState();
}

class _TransporterMainScreenState extends State<TransporterMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TransporterDashboard(),
    AvailablePickupsScreen(),
    MyDeliveriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, size: 32),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, size: 32),
            label: 'Pickups',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping, size: 32),
            label: 'Deliveries',
          ),
        ],
      ),
    );
  }
}
