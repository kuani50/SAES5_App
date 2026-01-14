import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../widgets/club_card.dart';
import '../widgets/header_home_page.dart';

class ClubScreen extends StatelessWidget {
  final List<EventModel> allEvents;

  const ClubScreen({super.key, required this.allEvents});

  @override
  Widget build(BuildContext context) {
    // Dummy data matching your screenshot
    final List<ClubModel> dummyClubs = [
      ClubModel(
        name: "Orient'Express",
        location: "Caen, 14",
        description: "Club organisateur du Raid Suisse Normande et des entraînements hebdomadaires.",
      ),
      ClubModel(
        name: "ALBE Orientation",
        location: "Elbeuf, 76",
        description: "Club de course d'orientation et de raid multisport en Seine-Maritime.",
      ),
      ClubModel(
        name: "Vikings 76",
        location: "Rouen, 76",
        description: "Association sportive dédiée à la course d'orientation et aux sports nature.",
      ),
      ClubModel(
        name: "ASL Condé",
        location: "Condé-sur-Noireau, 14",
        description: "Pratique de la course d'orientation pour tous, du loisir à la compétition.",
      ),
    ];

    // Responsive: 1 column on mobile, 2 on tablet/landscape
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
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
              itemCount: dummyClubs.length,
              itemBuilder: (context, index) {
                final club = dummyClubs[index];
                return ClubCard(
                  club: club,
                  onViewRaids: () {
                    context.push('/club-details', extra: {
                      'club': club,
                      'events': allEvents,
                    });
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
