import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swacch_setu/Alert_screen.dart';
import 'package:swacch_setu/History_screen.dart';
import 'package:swacch_setu/dashboard.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnection(); // ← Call on startup
  }

  Future<void> _checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://58e4-2409-40c2-10-be96-d7b-623f-516d-5e55.ngrok-free.app/',
            ),
            headers: {'ngrok-skip-browser-warning': 'true'},
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      setState(() {
        _isConnected = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AlertsScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Water',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          // IoT Connection Indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  _isConnected
                      ? const Color(0xFF00A86B).withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isConnected ? const Color(0xFF00A86B) : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isConnected
                                ? const Color(0xFF00A86B)
                                : Colors.red)
                            .withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isConnected ? 'Connected' : 'Offline',
                  style: TextStyle(
                    color: _isConnected ? const Color(0xFF00A86B) : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_rounded),
            label: 'Quality',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'History',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh data
          setState(() {});
          _checkConnection();
        },
        backgroundColor: const Color(0xFF00A8E8),
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}
