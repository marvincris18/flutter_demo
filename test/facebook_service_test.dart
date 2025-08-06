import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/services/facebook_service.dart';
import 'package:flutter_application_1/models/post_target.dart';
import 'package:flutter_application_1/models/social_post.dart';

void main() {
  group('FacebookService', () {
    late FacebookService facebookService;

    setUp(() {
      facebookService = FacebookService();
    });

    test('service name should be Facebook', () {
      expect(facebookService.serviceName, equals('Facebook'));
    });

    test('should return false when not authenticated initially', () async {
      final isAuth = await facebookService.isAuthenticated();
      expect(isAuth, isFalse);
    });

    test('should create social post correctly', () {
      const content = 'Test post content';
      const imageUrl = 'https://example.com/image.jpg';
      const hashtags = ['test', 'flutter'];
      
      final post = SocialPost(
        content: content,
        imageUrl: imageUrl,
        hashtags: hashtags,
      );

      expect(post.content, equals(content));
      expect(post.imageUrl, equals(imageUrl));
      expect(post.hashtags, equals(hashtags));
    });

    test('should create post target correctly', () {
      const target = PostTarget(
        id: 'test-id',
        name: 'Test Target',
        type: PostTargetType.wall,
        description: 'Test description',
        hasPermission: true,
      );

      expect(target.id, equals('test-id'));
      expect(target.name, equals('Test Target'));
      expect(target.type, equals(PostTargetType.wall));
      expect(target.description, equals('Test description'));
      expect(target.hasPermission, isTrue);
    });

    test('post targets should be equal when id and type match', () {
      const target1 = PostTarget(
        id: 'test-id',
        name: 'Test 1',
        type: PostTargetType.wall,
      );
      
      const target2 = PostTarget(
        id: 'test-id',
        name: 'Test 2',
        type: PostTargetType.wall,
      );

      expect(target1, equals(target2));
    });

    test('post targets should not be equal when id differs', () {
      const target1 = PostTarget(
        id: 'test-id-1',
        name: 'Test',
        type: PostTargetType.wall,
      );
      
      const target2 = PostTarget(
        id: 'test-id-2',
        name: 'Test',
        type: PostTargetType.wall,
      );

      expect(target1, isNot(equals(target2)));
    });

    test('should convert social post to JSON', () {
      const post = SocialPost(
        content: 'Test content',
        imageUrl: 'https://example.com/image.jpg',
        hashtags: ['test'],
      );

      final json = post.toJson();
      
      expect(json['content'], equals('Test content'));
      expect(json['imageUrl'], equals('https://example.com/image.jpg'));
      expect(json['hashtags'], equals(['test']));
    });

    test('should create social post from JSON', () {
      final json = {
        'content': 'Test content',
        'imageUrl': 'https://example.com/image.jpg',
        'hashtags': ['test'],
      };

      final post = SocialPost.fromJson(json);
      
      expect(post.content, equals('Test content'));
      expect(post.imageUrl, equals('https://example.com/image.jpg'));
      expect(post.hashtags, equals(['test']));
    });
  });
}