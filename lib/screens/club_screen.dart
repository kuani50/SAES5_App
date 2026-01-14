import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../data/club_data.dart';
import '../widgets/club_card.dart';
import '../widgets/header_home_page.dart';

class ClubScreen extends StatelessWidget {
  final List<EventModel> allEvents;

  const ClubScreen({super.key, required this.allEvents});

  @override
  Widget build(BuildContext context) {
    // Data from lib/data/club_data.dart
    final List<ClubModel> clubs = allClubs;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 2 : 1;

    return Scaffold(
      appBar: const HeaderHomePage(),
      body: SingleChildScrollView(
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
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.9,
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
      ),
    );
  }
}
