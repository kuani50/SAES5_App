import 'package:flutter/material.dart';
import '../models/club_model.dart';

class ClubCard extends StatelessWidget {
  final ClubModel club;
  final VoidCallback? onViewRaids;

  const ClubCard({super.key, required this.club, this.onViewRaids});

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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClubCardHeader(club: club),
          const SizedBox(height: 16),
          ClubCardActions(onTap: onViewRaids),
        ],
      ),
    );
  }
}

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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: club.logoUrl != null
              ? ClipOval(child: Image.network(club.logoUrl!, fit: BoxFit.cover))
              : Icon(Icons.shield, color: Colors.grey[500], size: 24),
        ),
        const SizedBox(width: 12),

        // Name and Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                club.location,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
