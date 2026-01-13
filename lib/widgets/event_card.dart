import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sous-composant Image
            EventCardImage(imageUrl: event.imageUrl),
            
            // Sous-composant Contenu
            Expanded(
              child: EventCardContent(event: event),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sous-composant : Image ---
class EventCardImage extends StatelessWidget {
  final String? imageUrl;

  const EventCardImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Hauteur fixe pour la partie image
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: imageUrl != null
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : Icon(Icons.image, size: 50, color: Colors.grey[400]),
      ),
    );
  }
}

// --- Sous-composant : Contenu Textuel ---
class EventCardContent extends StatelessWidget {
  final EventModel event;

  const EventCardContent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important pour éviter l'overflow
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: event.status),
              if (event.date.isNotEmpty)
                Expanded(
                  child: Text(
                    event.date,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16, // Légèrement réduit pour bien tenir
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.clubName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const Spacer(), // Pousse la localisation vers le bas
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Petit sous-composant pour le Badge ---
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.green[700],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}