import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/raid_provider.dart';
import '../providers/club_provider.dart';
import '../widgets/raid_list_section.dart';
import '../widgets/header_home_page.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch raids and clubs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RaidProvider>().fetchRaids();
      context.read<ClubProvider>().fetchClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderHomePage(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Raids Section ---
            Consumer<RaidProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.error != null) {
                  return Center(child: Text("Erreur Raids: ${provider.error}"));
                }

                final raids = provider.raids;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (raids.isNotEmpty)
                      HeroBanner(
                        title: 'Prochain défi : ${raids.first.name}',
                        onTap: () {
                          context.push('/details', extra: raids.first);
                        },
                      )
                    else
                      const HeroBanner(
                        title: 'Aucun raid disponible',
                        onTap: null,
                      ),
                    const SizedBox(height: 16),
                    RaidListSection(raids: raids),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
