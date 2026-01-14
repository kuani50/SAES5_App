import 'package:flutter/material.dart';
import '../widgets/header_home_page.dart';

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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SidebarItem(
                  icon: Icons.calendar_today,
                  text: "Mes Courses",
                  isActive: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                const SizedBox(height: 8),
                _SidebarItem(
                  icon: Icons.bar_chart,
                  text: "Mes Résultats",
                  isActive: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                const SizedBox(height: 8),
                _SidebarItem(
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
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildCoursesContent();
      case 1:
        return _buildResultsContent();
      default:
        // Placeholder for Profile or other sections
        return const Center(child: Text("Section en construction"));
    }
  }

  Widget _buildResultsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Historique des résultats",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1.5), // Date
              1: FlexColumnWidth(2), // Course
              2: FlexColumnWidth(1.5), // Temps
              3: FlexColumnWidth(1.5), // Classement
            },
            children: [
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                children: const [
                  _TableHeaderCell("Date"),
                  _TableHeaderCell("Course"),
                  _TableHeaderCell("Temps"),
                  _TableHeaderCell("Classement"),
                ],
              ),
              // Data Row
              TableRow(
                children: [
                  const _TableDataCell("10 Sept 2024"),
                  const _TableDataCell("Sprint Urbain"),
                  const _TableDataCell("01:45:22"),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "4e / 150",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row: Title
        Row(
          children: const [
            Text(
              "Mes Inscriptions",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Registration Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Icon Section
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),

                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: const Text(
                                "Raid Suisse Normande - Parcours Aventure",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 14,
                                    color: Colors.red.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      "Dossier incomplet",
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "12 Octobre • Équipe \"Les Gazelles\"",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _StatusBadge(
                              icon: Icons.check,
                              text: "Inscrit",
                              color: Colors.green,
                            ),
                            const SizedBox(width: 16),
                            _StatusBadge(
                              icon: Icons.description,
                              text: "Certificat manquant",
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(140, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Gérer Docs",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(140, 40),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Modifier Équipe",
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 12, // Reduced font size as requested
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.text,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.orange : Colors.grey.shade400,
          size: 20,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.orange : Colors.grey.shade400,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        horizontalTitleGap: 0,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final MaterialColor color;

  const _StatusBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _TableDataCell extends StatelessWidget {
  final String text;
  const _TableDataCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14),
      ),
    );
  }
}
