import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/raid_provider.dart';
import '../providers/club_provider.dart';
import '../widgets/club_card.dart';
import '../widgets/header_home_page.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClubProvider>().fetchClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We need raids to pass to the detail screen
    final allEvents = context.watch<RaidProvider>().raids;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;

    return Scaffold(
      appBar: const HeaderHomePage(),
      body: Consumer<ClubProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erreur: ${provider.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchClubs(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final clubs = provider.clubs;

          if (clubs.isEmpty) {
            return const Center(child: Text("Aucun club disponible."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Clubs Organisateurs",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 24),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: clubs.length,
                  itemBuilder: (context, index) {
                    final club = clubs[index];
                    return ClubCard(
                      club: club,
                      onViewRaids: () {
                        context.push(
                          '/club-details',
                          extra: {'club': club, 'events': allEvents},
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
