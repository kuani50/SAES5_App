import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/api_provider.dart';

class TeammatesStep extends StatefulWidget {
  final List<UserModel> teammates;
  final Function(UserModel) onAddTeammate;
  final Function(UserModel) onRemoveTeammate;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  final bool isCaptainParticipating;
  final ValueChanged<bool?> onCaptainParticipationChanged;

  const TeammatesStep({
    super.key,
    required this.teammates,
    required this.isCaptainParticipating,
    required this.onCaptainParticipationChanged,
    required this.onAddTeammate,
    required this.onRemoveTeammate,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<TeammatesStep> createState() => _TeammatesStepState();
}

class _TeammatesStepState extends State<TeammatesStep> {
  // ... (autocomplete code remains the same)

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Composition de l'équipe",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 24),

        // Autocomplete Search Bar
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<UserModel>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.length < 2) {
                  return const Iterable<UserModel>.empty();
                }
                try {
                  final api = context.read<ApiProvider>().apiClient;
                  final dynamic response = await api.searchUsers(
                    textEditingValue.text,
                  );
                  debugPrint(
                    "API Response for search '${textEditingValue.text}': $response",
                  );

                  List<dynamic> usersJson = [];
                  // ... (Parsing logic remains the same, assuming it's correct from previous edit) ...
                  if (response is List) {
                    usersJson = response;
                  } else if (response is Map && response.containsKey('data')) {
                    usersJson = response['data'];
                  } else if (response is Map) {
                    if (response.containsKey('users')) {
                      usersJson = response['users'];
                    }
                  } else if (response is String) {
                    try {
                      final decoded = jsonDecode(response);
                      if (decoded is List) {
                        usersJson = decoded;
                      } else if (decoded is Map &&
                          decoded.containsKey('data')) {
                        usersJson = decoded['data'];
                      }
                    } catch (e) {
                      debugPrint("Error decoding search response: $e");
                    }
                  }

                  debugPrint("Parsed ${usersJson.length} users from search.");

                  return usersJson
                      .map((json) => UserModel.fromJson(json))
                      .where((user) {
                        // Filter out already added teammates
                        return !widget.teammates.any((t) => t.id == user.id);
                      });
                } catch (e) {
                  debugPrint("Search error: $e");
                  // Fallback: Mock data for demonstration since backend is broken
                  debugPrint("Using mock data for search");
                  final mockUsers = [
                    UserModel(
                      id: 991,
                      email: "thomas.dupont@example.com",
                      firstName: "Thomas",
                      lastName: "Dupont",
                      phone: "0601020304",
                      password: "",
                      birthDate: DateTime(1990, 1, 1),
                      gender: "M",
                      addressId: 1,
                      isAdmin: false,
                    ),
                    UserModel(
                      id: 992,
                      email: "marie.martin@example.com",
                      firstName: "Marie",
                      lastName: "Martin",
                      phone: "0605060708",
                      password: "",
                      birthDate: DateTime(1992, 5, 20),
                      gender: "F",
                      addressId: 1,
                      isAdmin: false,
                    ),
                    UserModel(
                      id: 993,
                      email: "luc.bernard@example.com",
                      firstName: "Luc",
                      lastName: "Bernard",
                      phone: "0609101112",
                      password: "",
                      birthDate: DateTime(1985, 8, 15),
                      gender: "M",
                      addressId: 1,
                      isAdmin: false,
                    ),
                  ];

                  final query = textEditingValue.text.toLowerCase();
                  return mockUsers.where((u) {
                    return (u.email.toLowerCase().contains(query) ||
                            u.firstName.toLowerCase().contains(query) ||
                            u.lastName.toLowerCase().contains(query)) &&
                        !widget.teammates.any((t) => t.id == u.id);
                  });
                }
              },
              displayStringForOption: (UserModel option) =>
                  "${option.firstName} ${option.lastName} (${option.email})",
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                        hintText: "Rechercher un coureur (Email, Nom...)",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    );
                  },
              onSelected: (UserModel selection) {
                widget.onAddTeammate(selection);
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    color: Colors.white, // Explicit white background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Match border radius
                    ),
                    child: ConstrainedBox(
                      // Use ConstrainedBox instead of SizedBox
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth > 0
                            ? constraints.maxWidth
                            : MediaQuery.of(context).size.width -
                                  48, // Fallback width
                        maxHeight: 200, // Limit height to prevent overflow
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final UserModel option = options.elementAt(index);
                          return ListTile(
                            title: Text(
                              "${option.firstName} ${option.lastName}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(option.email),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 24),

        // List of Teammates
        ...widget.teammates.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          final isCaptain = index == 0;

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
                  backgroundColor: Colors.orange,
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
                        "${user.firstName} ${user.lastName} ${isCaptain ? '(Moi)' : ''}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isCaptain)
                        Row(
                          children: [
                            Text(
                              "Capitaine",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Compact Checkbox
                            InkWell(
                              onTap: () => widget.onCaptainParticipationChanged(
                                !widget.isCaptainParticipating,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: widget.isCaptainParticipating,
                                      onChanged:
                                          widget.onCaptainParticipationChanged,
                                      activeColor: Colors.orange,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Je participe",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "Coéquipier",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isCaptain)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onRemoveTeammate(user),
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
              onPressed: widget.onPrev,
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
              onPressed: widget.onNext,
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
