import 'package:flutter/material.dart';
import '../widgets/header_home_page.dart';
import '../widgets/sidebar_item.dart';
import 'tabs/user_races_tab.dart';
import 'tabs/user_results_tab.dart';
import 'tabs/user_profile_tab.dart';

class UserRacesScreen extends StatefulWidget {
  const UserRacesScreen({super.key});

  @override
  State<UserRacesScreen> createState() => _UserRacesScreenState();
}

class _UserRacesScreenState extends State<UserRacesScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(isLoggedIn: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          if (isWideScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar (Desktop)
                Container(
                  width: 250,
                  color: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SidebarItem(
                        icon: Icons.calendar_today,
                        text: "Mes Courses",
                        isActive: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      const SizedBox(height: 8),
                      SidebarItem(
                        icon: Icons.bar_chart,
                        text: "Mes Résultats",
                        isActive: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      const SizedBox(height: 8),
                      SidebarItem(
                        icon: Icons.person,
                        text: "Mon Profil",
                        isActive: _selectedIndex == 2,
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    child: _buildContent(),
                  ),
                ),
              ],
            );
          } else {
            // Mobile Layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(),
            );
          }
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 800
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              backgroundColor: const Color(0xFF0F172A),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: "Courses",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: "Résultats",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profil",
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const UserRacesTab();
      case 1:
        return const UserResultsTab();
      case 2:
        return const UserProfileTab();
      default:
        return const Center(child: Text("Section en construction"));
    }
  }
}
