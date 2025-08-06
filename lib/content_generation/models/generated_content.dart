class GeneratedContent {
  final String content;
  final DateTime createdAt;
  final String keywords;
  final String tone;
  final String style;

  GeneratedContent({
    required this.content,
    required this.createdAt,
    required this.keywords,
    required this.tone,
    required this.style,
  });

  factory GeneratedContent.fromJson(Map<String, dynamic> json) {
    return GeneratedContent(
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      keywords: json['keywords'] as String,
      tone: json['tone'] as String,
      style: json['style'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'keywords': keywords,
      'tone': tone,
      'style': style,
    };
  }
}