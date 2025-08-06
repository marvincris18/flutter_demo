enum ContentTone {
  professional,
  humorous,
  casual,
}

enum ContentStyle {
  concise,
  detailed,
}

class ContentRequest {
  final String keywords;
  final ContentTone tone;
  final ContentStyle style;
  final String? additionalInstructions;

  ContentRequest({
    required this.keywords,
    required this.tone,
    required this.style,
    this.additionalInstructions,
  });

  String get toneDescription {
    switch (tone) {
      case ContentTone.professional:
        return 'professional';
      case ContentTone.humorous:
        return 'humorous';
      case ContentTone.casual:
        return 'casual';
    }
  }

  String get styleDescription {
    switch (style) {
      case ContentStyle.concise:
        return 'concise';
      case ContentStyle.detailed:
        return 'detailed';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'keywords': keywords,
      'tone': toneDescription,
      'style': styleDescription,
      'additionalInstructions': additionalInstructions,
    };
  }
}