import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content_generation_state.dart';
import '../models/content_request.dart';
import 'tone_selector.dart';
import 'style_selector.dart';
import 'generated_content_card.dart';

class ContentGenerationPage extends StatefulWidget {
  @override
  _ContentGenerationPageState createState() => _ContentGenerationPageState();
}

class _ContentGenerationPageState extends State<ContentGenerationPage> {
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _keywordsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentGenerationState>(
      builder: (context, contentState, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Content Generator',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Generate engaging content with customizable tone and style',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputSection(contentState),
                      const SizedBox(height: 24),
                      _buildOptionsSection(contentState),
                      const SizedBox(height: 24),
                      _buildGenerateButton(contentState),
                      const SizedBox(height: 24),
                      _buildResultSection(contentState),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputSection(ContentGenerationState contentState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keywordsController,
              decoration: const InputDecoration(
                labelText: 'Keywords or Themes *',
                hintText: 'e.g., social media marketing, product launch, team building',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => contentState.setKeywords(value),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Additional Instructions (Optional)',
                hintText: 'Any specific requirements or context...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              onChanged: (value) => contentState.setAdditionalInstructions(value),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection(ContentGenerationState contentState) {
    return Row(
      children: [
        Expanded(
          child: ToneSelector(
            selectedTone: contentState.selectedTone,
            onToneChanged: contentState.setTone,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StyleSelector(
            selectedStyle: contentState.selectedStyle,
            onStyleChanged: contentState.setStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton(ContentGenerationState contentState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: contentState.isLoading ? null : () {
          contentState.clearError();
          contentState.generateContent();
        },
        icon: contentState.isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
        label: Text(
          contentState.isLoading ? 'Generating...' : 'Generate Content',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResultSection(ContentGenerationState contentState) {
    if (contentState.error != null) {
      return Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  contentState.error!,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ),
              IconButton(
                onPressed: contentState.clearError,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      );
    }

    if (contentState.lastGeneratedContent != null) {
      return GeneratedContentCard(
        content: contentState.lastGeneratedContent!,
        isLatest: true,
      );
    }

    return const SizedBox.shrink();
  }
}