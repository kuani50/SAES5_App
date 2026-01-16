import 'package:flutter/material.dart';
import 'dart:async';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<UserModel> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _lastQuery = query;
        _isSearching = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchUsers(query);
    });
  }

  Future<void> _searchUsers(String query) async {
    try {
      final api = context.read<ApiProvider>().apiClient;
      final dynamic response = await api.searchUsers(query);

      List<dynamic> usersJson = [];
      if (response is List) {
        usersJson = response;
      } else if (response is Map &&
          response.containsKey('data') &&
          response['data'] is List) {
        usersJson = response['data'];
      } else if (response is String) {
        try {
          final decoded = jsonDecode(response);
          if (decoded is List) {
            usersJson = decoded;
          }
        } catch (e) {
          debugPrint("Error decoding search response: $e");
        }
      }

      final users = usersJson
          .map((json) {
            try {
              return UserModel.fromJson(json);
            } catch (e) {
              return null;
            }
          })
          .whereType<UserModel>()
          .toList();

      if (mounted) {
        setState(() {
          _searchResults = users;
          _lastQuery = query;
          _isSearching = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      debugPrint("Search users error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Erreur lors de la recherche.";
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final captainId = widget.teammates.isNotEmpty
        ? widget.teammates.first.id
        : null;

    final selectableUsers = _searchResults
        .where((u) => u.id != captainId)
        .toList();

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

        if (widget.teammates.isNotEmpty) ...[
          _buildUserTile(widget.teammates.first, isCaptain: true),
          const SizedBox(height: 24),
        ],

        // Selected teammates section (excluding captain)
        if (widget.teammates.length > 1) ...[
          const Text(
            "Coéquipiers sélectionnés",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.teammates
              .skip(1)
              .map(
                (user) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSelectedTeammateTile(user),
                ),
              ),
          const SizedBox(height: 16),
        ],

        const Text(
          "Rechercher des coéquipiers",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Search TextField
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: "Rechercher par nom ou email (min. 2 caractères)",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Search Results
        if (_isSearching)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_errorMessage != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        else if (_lastQuery.length < 2)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey),
                SizedBox(width: 12),
                Expanded(
                  child: Text("Entrez au moins 2 caractères pour rechercher."),
                ),
              ],
            ),
          )
        else if (selectableUsers.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_off, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text("Aucun utilisateur trouvé pour \"$_lastQuery\"."),
                ),
              ],
            ),
          )
        else
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: selectableUsers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = selectableUsers[index];
                final isSelected = widget.teammates.any((t) => t.id == user.id);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Colors.orange
                        : Colors.orange.shade100,
                    child: Text(
                      user.firstName.isNotEmpty
                          ? user.firstName[0].toUpperCase()
                          : "?",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                  title: Text(
                    "${user.firstName} ${user.lastName}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(user.email),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.orange)
                      : IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.orange,
                          onPressed: () => widget.onAddTeammate(user),
                        ),
                  onTap: isSelected ? null : () => widget.onAddTeammate(user),
                );
              },
            ),
          ),

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

  Widget _buildSelectedTeammateTile(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.orange.shade50,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.orange,
            child: Text(
              user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : "?",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: Colors.red.shade400,
            onPressed: () => widget.onRemoveTeammate(user),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(UserModel user, {bool isCaptain = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: isCaptain ? Colors.orange.shade50 : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : "?",
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
                                onChanged: widget.onCaptainParticipationChanged,
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
