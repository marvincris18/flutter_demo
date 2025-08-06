class SocialPost {
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final List<String>? hashtags;
  final Map<String, dynamic>? metadata;

  const SocialPost({
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.hashtags,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'hashtags': hashtags,
      'metadata': metadata,
    };
  }

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      hashtags: (json['hashtags'] as List<dynamic>?)?.cast<String>(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  SocialPost copyWith({
    String? content,
    String? imageUrl,
    String? videoUrl,
    List<String>? hashtags,
    Map<String, dynamic>? metadata,
  }) {
    return SocialPost(
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      hashtags: hashtags ?? this.hashtags,
      metadata: metadata ?? this.metadata,
    );
  }
}