import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../models/user_model.dart';
// import 'package:provider/provider.dart';

class DocsStep extends StatelessWidget {
  final List<UserModel> teammates;
  final bool isCaptainParticipating;
  final Map<int, File> uploadedDocs;
  final Function(int, File) onUploadDoc;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const DocsStep({
    super.key,
    required this.teammates,
    required this.isCaptainParticipating,
    required this.uploadedDocs,
    required this.onUploadDoc,
    required this.onNext,
    required this.onPrev,
  });

  Future<void> _pickPdf(int userId) async {
    // ...
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      onUploadDoc(userId, File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Justificatifs Médicaux",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),

        // Info box explaining optional upload
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Le téléversement des documents est optionnel. Vous pourrez les ajouter ultérieurement depuis votre espace personnel.",
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        ...teammates.map((user) {
          final isCaptain = teammates.indexOf(user) == 0;

          // If captain is NOT participating, they don't need docs
          if (isCaptain && !isCaptainParticipating) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      user.firstName.isNotEmpty
                          ? user.firstName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Gestionnaire (Pas de participation)",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final hasLicense =
              user.licenseNumber != null && user.licenseNumber!.isNotEmpty;
          final hasUploaded = uploadedDocs.containsKey(user.id);

          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isCaptain
                      ? Colors.orange
                      : Colors.deepOrange,
                  child: Text(
                    user.firstName.isNotEmpty
                        ? user.firstName[0].toUpperCase()
                        : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (hasLicense)
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Licence validée (${user.licenseNumber})",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          hasUploaded
                              ? "Document ajouté"
                              : "Aucun document (optionnel)",
                          style: TextStyle(
                            color: hasUploaded
                                ? Colors.blue.shade700
                                : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                if (hasLicense)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (hasUploaded)
                  const Icon(Icons.picture_as_pdf, color: Colors.red)
                else
                  OutlinedButton.icon(
                    onPressed: () => _pickPdf(user.id),
                    icon: const Icon(Icons.upload_file, size: 16),
                    label: const Text("Téléverser"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
              ],
            ),
          );
        }),

        const SizedBox(height: 48),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: onPrev,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text("Précédent"),
            ),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Row(
                children: [
                  Text("Suivant"),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
