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
            // Titre / Logo à gauche
            const Text(
              "Orient'Express",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

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
                    child: const Text(
                      'Prochains Événements',
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
                    child: const Text(
                      'Club',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            if (isLandscape) ...[
              if (isLoggedIn) ...[
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {},
                  tooltip: 'Mon Profil',
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: onLogout,
                  tooltip: 'Se déconnecter',
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {}, // TODO: Inscription
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Créer un compte'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {}, // TODO: Connexion
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Connexion'),
                ),
              ],
            ] else ...[
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle, size: 28),
                onSelected: (value) {
                  switch (value) {
                    case 'login':
                    case 'register':
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
