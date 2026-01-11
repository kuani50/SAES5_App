import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class DetailScreen extends StatelessWidget {
  final Project project;

  const DetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final baseUrl = context.read<ProjectProvider>().baseUrl;
    final imageUrl = project.getFullImageUrl(baseUrl);
    final dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  height: 250,
                  child: Center(child: const Icon(Icons.error)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(project.category)),
                      const Spacer(),
                      Text('Created: ${dateFormat.format(project.createdAt)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}