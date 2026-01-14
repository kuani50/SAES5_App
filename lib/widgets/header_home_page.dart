import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderHomePage extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback? onLogout;

  const HeaderHomePage({super.key, this.isLoggedIn = false, this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // ---  Get current route to highlight the active tab. ---
    final String currentPath = GoRouterState.of(context).uri.path;
    final bool isRaidsActive =
        currentPath == '/home' || currentPath.startsWith('/details');
    final bool isClubsActive = currentPath.startsWith('/clubs');
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return AppBar(
      backgroundColor: const Color(0xFF334C33),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // --- Made the logo tappable to navigate home. ---
            GestureDetector(
              onTap: () => context.go('/home'),
              child: const Text(
                "Orient'Express",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            // --- Central expanding navigation ---
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    // --- Conditional styling for the active tab. ---
                    child: Text(
                      'Raids',
                      style: TextStyle(
                        color: isRaidsActive ? Colors.orange : Colors.white,
                        fontWeight: isRaidsActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  TextButton(
                    onPressed: () {
                      context.go('/clubs');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    // --- Conditional styling for the active tab. ---
                    child: Text(
                      'Club',
                      style: TextStyle(
                        color: isClubsActive ? Colors.orange : Colors.white,
                        fontWeight: isClubsActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  TextButton(
                    onPressed: () {
                      context.go('/my-races');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Mon espace coureur',
                      style: TextStyle(
                        color: currentPath == '/my-races'
                            ? Colors.orange
                            : Colors.white,
                        fontWeight: currentPath == '/my-races'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Responsive Logic for Authentication on the right ---
            if (isLandscape) ...[
              // LANDSCAPE MODE: Everything visible
              if (isLoggedIn) ...[
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {},
                  tooltip: 'Mon Profil',
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: onLogout,
                  tooltip: 'Se déconnecter',
                ),
              ] else ...[
                // Guest (Landscape)
                ElevatedButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Créer un compte'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Connexion'),
                ),
              ],
            ] else ...[
              // PORTRAIT MODE: Dropdown menu for auth
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.account_circle,
                  size: 28,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'login':
                      context.go('/login');
                      break;
                    case 'register':
                      context.go('/register');
                      break;
                    case 'profile':
                      break;
                    case 'logout':
                      if (onLogout != null) onLogout!();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    if (isLoggedIn) ...[
                      const PopupMenuItem(
                        value: 'profile',
                        child: Text('Mon Profil'),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text(
                          'Se déconnecter',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ] else ...[
                      const PopupMenuItem(
                        value: 'login',
                        child: Text('Connexion'),
                      ),
                      const PopupMenuItem(
                        value: 'register',
                        child: Text('Créer un compte'),
                      ),
                    ],
                  ];
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
