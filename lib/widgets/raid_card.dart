import 'package:flutter/material.dart';
import '../models/raid_model.dart';

class RaidCard extends StatelessWidget {
  final RaidModel raid;
  final VoidCallback? onTap;

  const RaidCard({super.key, required this.raid, this.onTap});

  String _getStatus(RaidModel raid) {
    final now = DateTime.now();
    if (now.isBefore(raid.registrationStartDate)) {
      return "Bientôt";
    } else if (now.isAfter(raid.registrationEndDate)) {
      return "Terminé"; // Or "Inscriptions closes"
    } else {
      return "Inscription ouverte";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
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
            RaidCardImage(imageUrl: raid.imageUrl),
            Expanded(
              child: RaidCardContent(raid: raid, status: _getStatus(raid)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sub-component: Image ---
class RaidCardImage extends StatelessWidget {
  final String? imageUrl;

  const RaidCardImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              )
            : Icon(Icons.image, size: 50, color: Colors.grey[400]),
      ),
    );
  }
}

// --- Sub-component: Text Content ---
class RaidCardContent extends StatelessWidget {
  final RaidModel raid;
  final String status;

  const RaidCardContent({super.key, required this.raid, required this.status});

  @override
  Widget build(BuildContext context) {
    // Basic date formatting
    final dateStr =
        "${raid.startDate.day}/${raid.startDate.month}/${raid.startDate.year}";

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: status),
              Text(
                "Raid à venir", // Generic placeholder or derive from dates
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            raid.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  raid.club?.name ?? "Club #${raid.clubId ?? '?'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  raid.address != null
                      ? "${raid.address!.city ?? ''} ${raid.address!.postalCode ?? ''}"
                      : "Adresse #${raid.addressId ?? '?'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Courses Section
          if (raid.courses.isNotEmpty)
            SizedBox(
              height: 24,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: raid.courses.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final course = raid.courses[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Text(
                      course.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// --- Small sub-component for Badge ---
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.green[50]!;
    Color textColor = Colors.green[700]!;

    if (status == "Terminé" || status == "Complet") {
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
    } else if (status == "Bientôt") {
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
