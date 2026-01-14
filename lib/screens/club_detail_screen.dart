import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';
import '../widgets/header_home_page.dart';

class ClubDetailScreen extends StatelessWidget {
  final ClubModel club;
  final List<EventModel> allEvents; // On passe tous les événements pour filtrer

  const ClubDetailScreen({
    super.key,
    required this.club,
    required this.allEvents,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrage des raids organisés par ce club
    final clubEvents = allEvents.where((e) => e.clubName == club.name).toList();

    return Scaffold(
      appBar: const HeaderHomePage(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bouton Retour
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 18),
              label: const Text(
                "Retour aux clubs",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
            const SizedBox(height: 24),

            // Infos du Club
            _ClubDetailInfo(club: club),
            const SizedBox(height: 40),

            // Titre de la section
            const Text(
              "Raids organisés par ce club",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 24),

            // Grille des Raids
            if (clubEvents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text("Ce club n'a pas encore organisé de raids."),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // --- MODIFICATION : Plus de cartes par ligne ---
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  // --- MODIFICATION : Ratio ajusté pour des cartes moins hautes ---
                  childAspectRatio: 0.85, // Ancien : 0.75
                ),
                itemCount: clubEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(
                    event: clubEvents[index],
                    onTap: () => context.push('/details', extra: clubEvents[index]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// --- Sous-composant : Infos du Club ---
class _ClubDetailInfo extends StatelessWidget {
  final ClubModel club;

  const _ClubDetailInfo({required this.club});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: club.logoUrl != null
              ? ClipOval(child: Image.network(club.logoUrl!, fit: BoxFit.cover))
              : Icon(Icons.shield, color: Colors.grey[400], size: 50),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Club - ${club.location}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
