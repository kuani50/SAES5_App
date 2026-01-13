import 'package:flutter/material.dart';
import '../models/club_model.dart';
import '../widgets/club_card.dart';
import '../widgets/header_home_page.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Données factices correspondant à votre screenshot
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
      // J'en rajoute pour tester la grille
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

    // Responsive : 1 colonne en mobile, 2 en tablette/paysage, 3 en grand écran
    // Pour rester simple et efficace comme la Home :
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 2 : 1; // 1 colonne sur mobile c'est souvent mieux pour ce type de carte détaillée

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
                childAspectRatio: 1.5, // Ratio plus large pour que le texte rentre bien
                // Si ça déborde sur mobile, il faudra peut-être réduire ce ratio ou utiliser un package de grille dynamique (StaggeredGrid)
                // En mobile (1 colonne), on ajustera.
              ),
              itemCount: dummyClubs.length,
              itemBuilder: (context, index) {
                return ClubCard(
                  club: dummyClubs[index],
                  onViewRaids: () {
                    // TODO: Navigation vers les raids de ce club
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
