import 'package:flutter/material.dart';
import '../models/club_model.dart';

class ClubCard extends StatelessWidget {
  final ClubModel club;
  final VoidCallback? onViewRaids;

  const ClubCard({
    super.key,
    required this.club,
    this.onViewRaids,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Logo + Name)
          ClubCardHeader(club: club),
          const SizedBox(height: 16),
          ClubCardDescription(description: club.description),
          const SizedBox(height: 24),
          ClubCardActions(onTap: onViewRaids),
        ],
      ),
    );
  }
}

// Header (Logo + Info)
class ClubCardHeader extends StatelessWidget {
  final ClubModel club;

  const ClubCardHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Round Logo (Placeholder)
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: club.logoUrl != null
              ? ClipOval(child: Image.network(club.logoUrl!, fit: BoxFit.cover))
              : Icon(Icons.shield, color: Colors.grey[500], size: 30),
        ),
        const SizedBox(width: 16),
        
        // Name and Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                club.location,
                style: TextStyle(
                  fontSize: 14,
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

// --- Sub-component: Description ---
class ClubCardDescription extends StatelessWidget {
  final String description;

  const ClubCardDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.5,
      ),
    );
  }
}

// --- Sub-component: Actions ---
class ClubCardActions extends StatelessWidget {
  final VoidCallback? onTap;

  const ClubCardActions({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Voir les raids',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
