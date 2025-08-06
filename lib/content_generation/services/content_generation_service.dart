import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/content_request.dart';
import '../models/generated_content.dart';

class ContentGenerationService {
  // In a real app, this would be your actual API endpoint
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  
  // For demo purposes, we'll simulate content generation
  static const List<String> _sampleContents = [
    "Transform your business with innovative solutions that drive growth and engagement.",
    "Ready to make a splash? Dive into our amazing new features that'll blow your mind! 🚀",
    "Here's a quick update on what's happening in our world. Simple, straightforward, and to the point.",
    "Unlock the potential of your organization through strategic implementation of cutting-edge technologies and methodologies.",
    "Who says work can't be fun? Join us for an adventure in productivity and creativity! Let's make magic happen together.",
    "Just wanted to share some thoughts on the latest trends. Nothing fancy, just real talk about what matters.",
  ];

  Future<GeneratedContent> generateContent(ContentRequest request) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo purposes, we'll use predefined content
    // In a real app, you would make an actual API call to OpenAI or similar service
    final content = _generateMockContent(request);
    
    return GeneratedContent(
      content: content,
      createdAt: DateTime.now(),
      keywords: request.keywords,
      tone: request.toneDescription,
      style: request.styleDescription,
    );
  }

  String _generateMockContent(ContentRequest request) {
    final random = Random();
    String baseContent = _sampleContents[random.nextInt(_sampleContents.length)];
    
    // Modify content based on tone
    switch (request.tone) {
      case ContentTone.professional:
        baseContent = _makeProfessional(baseContent);
        break;
      case ContentTone.humorous:
        baseContent = _makeHumorous(baseContent);
        break;
      case ContentTone.casual:
        baseContent = _makeCasual(baseContent);
        break;
    }
    
    // Modify content based on style
    if (request.style == ContentStyle.detailed) {
      baseContent = _makeDetailed(baseContent);
    } else {
      baseContent = _makeConcise(baseContent);
    }
    
    // Include keywords
    if (request.keywords.isNotEmpty) {
      baseContent = '$baseContent\n\nKeywords: ${request.keywords}';
    }
    
    return baseContent;
  }

  String _makeProfessional(String content) {
    return content.replaceAll('!', '.').replaceAll('🚀', '');
  }

  String _makeHumorous(String content) {
    final jokes = [' 😄', ' (just kidding!)', ' - but seriously though...'];
    final random = Random();
    return content + jokes[random.nextInt(jokes.length)];
  }

  String _makeCasual(String content) {
    return content.toLowerCase().replaceFirst(content[0], content[0].toUpperCase());
  }

  String _makeDetailed(String content) {
    return '$content\n\nThis comprehensive approach ensures maximum effectiveness by addressing key factors that contribute to successful outcomes. Our methodology incorporates best practices and proven strategies.';
  }

  String _makeConcise(String content) {
    final sentences = content.split('.');
    return sentences.take(1).join('.') + (sentences.isNotEmpty ? '.' : '');
  }

  // Future method for actual API integration
  Future<String> _callActualAPI(ContentRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY', // Replace with actual API key
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': 'Generate ${request.styleDescription} content with a ${request.toneDescription} tone about: ${request.keywords}',
            }
          ],
          'max_tokens': request.style == ContentStyle.detailed ? 300 : 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling AI service: $e');
    }
  }
}