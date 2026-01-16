import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/header_home_page.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class ManageTeamScreen extends StatefulWidget {
  final int? teamId;
  final String? teamName;
  final String? raceName;
  final String? raidName;

  const ManageTeamScreen({
    super.key,
    this.teamId,
    this.teamName,
    this.raceName,
    this.raidName,
  });

  @override
  State<ManageTeamScreen> createState() => _ManageTeamScreenState();
}

class _ManageTeamScreenState extends State<ManageTeamScreen> {
  bool _isLoading = true;
  String? _error;
  String _teamName = "";
  String _eventName = "";
  List<Map<String, dynamic>> _members = [];
  int? _managerId;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<UserModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _teamName = widget.teamName ?? "";
    _eventName = "${widget.raceName ?? ''} - ${widget.raidName ?? ''}";
    if (widget.teamId != null) {
      _fetchTeamDetails();
    } else {
      setState(() {
        _isLoading = false;
        _error = "Aucune équipe sélectionnée";
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final apiProvider = context.read<ApiProvider>();
      final dynamic response = await apiProvider.apiClient.getTeam(
        widget.teamId!,
      );

      debugPrint('getTeam response: $response');

      var responseData = response;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      // Extract team data
      Map<String, dynamic> teamData = {};
      if (responseData is Map) {
        if (responseData.containsKey('data')) {
          teamData = responseData['data'] as Map<String, dynamic>;
        } else {
          teamData = responseData as Map<String, dynamic>;
        }
      }

      // Extract members
      List<Map<String, dynamic>> members = [];
      final membersList = teamData['members'] ?? teamData['users'] ?? [];
      if (membersList is List) {
        for (var member in membersList) {
          if (member is Map) {
            final firstName = member['first_name']?.toString() ?? '';
            final lastName = member['last_name']?.toString() ?? '';
            final name = '$firstName $lastName'.trim();
            final initials =
                '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                    .toUpperCase();

            members.add({
              'id': member['id'],
              'name': name.isNotEmpty ? name : 'Utilisateur',
              'email': member['email']?.toString() ?? '',
              'initials': initials.isNotEmpty ? initials : 'U',
              'isCaptain':
                  member['id'] == teamData['manager_id'] ||
                  member['pivot']?['is_captain'] == true ||
                  member['pivot']?['is_captain'] == 1,
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          _teamName =
              teamData['name']?.toString() ?? widget.teamName ?? "Équipe";
          _managerId = teamData['manager_id'];
          _members = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching team details: $e');
      if (mounted) {
        setState(() {
          _error = "Impossible de charger les détails de l'équipe";
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchUsers(query);
    });
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) return;

    setState(() => _isSearching = true);

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
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .where(
            (user) => !_members.any((m) => m['id'] == user.id),
          ) // Exclude existing members
          .toList();

      if (mounted) {
        setState(() {
          _searchResults = users;
          _isSearching = false;
        });
      }
    } catch (e) {
      debugPrint('Error searching users: $e');
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _addMember(UserModel user) {
    setState(() {
      _members.add({
        'id': user.id,
        'name': '${user.firstName} ${user.lastName}'.trim(),
        'email': user.email,
        'initials':
            '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}'
                .toUpperCase(),
        'isCaptain': false,
        'isNew': true,
      });
      _searchResults = [];
      _searchController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.firstName} ${user.lastName} ajouté à l\'équipe'),
      ),
    );
  }

  void _removeMember(int index) {
    final member = _members[index];
    setState(() {
      _members.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${member['name']} supprimé de l\'équipe')),
    );
  }

  Future<void> _saveChanges() async {
    if (widget.teamId == null) return;

    try {
      final apiProvider = context.read<ApiProvider>();
      final memberIds = _members.map((m) => m['id']).toList();

      await apiProvider.apiClient.updateTeamMembers(widget.teamId!, {
        'member_ids': memberIds,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Équipe mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving team changes: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final isManager = currentUser != null && _managerId == currentUser.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderHomePage(isLoggedIn: true),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/my-races'),
                        child: const Text("Retour à mes courses"),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      TextButton.icon(
                        onPressed: () => context.go('/my-races'),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF0F172A),
                        ),
                        label: const Text(
                          "Retour à mes courses",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        "Gérer l'équipe \"$_teamName\"",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _eventName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Search section (only for manager)
                      if (isManager) ...[
                        const Text(
                          "Ajouter un participant",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText:
                                "Rechercher un utilisateur (min. 2 caractères)...",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        // Search results
                        if (_searchResults.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}'
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${user.firstName} ${user.lastName}',
                                  ),
                                  subtitle: Text(user.email),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => _addMember(user),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],

                      // Members list
                      const Text(
                        "Membres de l'équipe",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _members.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text(
                                  "Aucun membre dans l'équipe",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _members.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                itemBuilder: (context, index) {
                                  final member = _members[index];
                                  final isCaptain = member['isCaptain'] == true;
                                  final isNew = member['isNew'] == true;

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: isCaptain
                                          ? Colors.orange.shade100
                                          : Colors.blueGrey.shade100,
                                      child: Text(
                                        member['initials'] ?? 'U',
                                        style: TextStyle(
                                          color: isCaptain
                                              ? Colors.orange.shade800
                                              : const Color(0xFF0F172A),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          member['name'] ?? 'Utilisateur',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (isNew) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "Nouveau",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green.shade800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Text(
                                      isCaptain
                                          ? "Chef d'équipe"
                                          : member['email']?.toString() ?? '',
                                      style: TextStyle(
                                        color: isCaptain
                                            ? Colors.orange.shade700
                                            : Colors.grey,
                                      ),
                                    ),
                                    trailing: isCaptain || !isManager
                                        ? null
                                        : IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _removeMember(index),
                                            tooltip: 'Supprimer ce membre',
                                          ),
                                  );
                                },
                              ),
                      ),

                      // Save button (only for manager)
                      if (isManager &&
                          _members.any((m) => m['isNew'] == true)) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Sauvegarder les modifications",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
