import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch projects when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ProjectProvider>();
      // Ensure the saved URL is loaded if we skipped the config screen (Release mode)
      await provider.loadSavedUrl();
      provider.fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Portfolio')),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchProjects(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.projects.isEmpty) {
            return const Center(child: Text('No projects found.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchProjects(),
            child: ListView.builder(
              itemCount: provider.projects.length,
              itemBuilder: (context, index) {
                final project = provider.projects[index];
                final imageUrl = project.getFullImageUrl(provider.baseUrl);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      context.push('/details', extra: project);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl != null)
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                    color: Colors.grey,
                                    child: const Icon(Icons.error),
                                  ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Chip(label: Text(project.category)),
                              const SizedBox(height: 8),
                              Text(
                                project.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
