import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/api_provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the current URL from provider into the controller
    final provider = context.read<ApiProvider>();
    _urlController.text = provider.baseUrl;

    // Attempt to load saved URL from disk
    // Note: ApiProvider loads saved data in constructor, so baseUrl might already be set.
    // If not, it's fine.
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _validateAndContinue() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      context.read<ApiProvider>().setBaseUrl(url);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Entrez l\'URL de l\'API',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'API Base URL',
                border: OutlineInputBorder(),
                hintText: 'https://sae.bananacloud.tech',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Valider et Continuer'),
            ),
          ],
        ),
      ),
    );
  }
}
