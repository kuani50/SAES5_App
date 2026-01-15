import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HeaderHomePage extends StatelessWidget implements PreferredSizeWidget {
  final bool? isLoggedIn;
  final VoidCallback? onLogout;

  const HeaderHomePage({super.key, this.isLoggedIn, this.onLogout});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final bool loggedIn = isLoggedIn ?? provider.isAuthenticated;
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
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Cari'Boussole",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
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
                  if (loggedIn) ...[
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
                ],
              ),
            ),

            if (isLandscape) ...[
              if (loggedIn) ...[
                // Display user name
                if (provider.userDisplayName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      provider.userDisplayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                // Course Manager Icon (gear) - only show if user is a race manager
                if (provider.isRaceManager)
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => context.go('/mes-courses'),
                    tooltip: 'Mes Courses (Responsable)',
                  ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {},
                  tooltip: 'Mon Profil',
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () {
                    provider.logout();
                    context.go('/home');
                  },
                  tooltip: 'Se déconnecter',
                ),
              ] else ...[
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
                icon: loggedIn && provider.userDisplayName.isNotEmpty
                    ? CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.orange,
                        child: Text(
                          provider.currentUser?.firstName
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              "U",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const Icon(
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
                      provider.logout();
                      context.go('/home');
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    if (loggedIn) ...[
                      if (provider.userDisplayName.isNotEmpty)
                        PopupMenuItem(
                          enabled: false,
                          child: Text(
                            provider.userDisplayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
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
