import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/content_generation/models/content_request.dart';
import 'package:flutter_application_1/content_generation/models/generated_content.dart';
import 'package:flutter_application_1/content_generation/services/content_generation_service.dart';

void main() {
  group('Content Generation', () {
    test('ContentRequest should have correct tone and style descriptions', () {
      final request = ContentRequest(
        keywords: 'test keywords',
        tone: ContentTone.professional,
        style: ContentStyle.detailed,
      );

      expect(request.toneDescription, 'professional');
      expect(request.styleDescription, 'detailed');
      expect(request.keywords, 'test keywords');
    });

    test('ContentGenerationService should generate mock content', () async {
      final service = ContentGenerationService();
      final request = ContentRequest(
        keywords: 'social media',
        tone: ContentTone.humorous,
        style: ContentStyle.concise,
      );

      final result = await service.generateContent(request);

      expect(result.keywords, 'social media');
      expect(result.tone, 'humorous');
      expect(result.style, 'concise');
      expect(result.content.isNotEmpty, true);
      expect(result.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))), true);
    });

    test('GeneratedContent should serialize to/from JSON', () {
      final content = GeneratedContent(
        content: 'Test content',
        createdAt: DateTime(2024, 1, 1),
        keywords: 'test',
        tone: 'professional',
        style: 'concise',
      );

      final json = content.toJson();
      final recreated = GeneratedContent.fromJson(json);

      expect(recreated.content, content.content);
      expect(recreated.keywords, content.keywords);
      expect(recreated.tone, content.tone);
      expect(recreated.style, content.style);
      expect(recreated.createdAt, content.createdAt);
    });
  });
}