# Flutter Demo - AI Content Generator

A Flutter application that includes an AI-powered content generation feature alongside the original word pair generator.

## Features

### Original Features
- **Word Pair Generator**: Generate random word pairs
- **Favorites**: Save and manage favorite word pairs

### New AI Content Generation Feature
- **Content Generation**: Generate text content using AI-based models
- **Tone Selection**: Choose from Professional, Humorous, or Casual tones
- **Style Selection**: Choose between Concise or Detailed styles
- **Keyword Input**: Specify keywords or themes to guide content generation
- **Additional Instructions**: Optional field for specific requirements
- **Copy to Clipboard**: Easy copying of generated content
- **Content History**: Keep track of previously generated content

## Architecture

The content generation feature is built with a modular architecture:

```
lib/content_generation/
├── models/
│   ├── content_request.dart        # Request data structure
│   ├── generated_content.dart      # Generated content data structure
│   └── content_generation_state.dart # State management
├── services/
│   └── content_generation_service.dart # Content generation logic
└── widgets/
    ├── content_generation_page.dart     # Main page widget
    ├── tone_selector.dart              # Tone selection widget
    ├── style_selector.dart             # Style selection widget
    └── generated_content_card.dart     # Content display widget
```

## State Management

The app uses the Provider pattern for state management:
- `MyAppState`: Manages word pairs and favorites
- `ContentGenerationState`: Manages content generation process, selections, and history

## Navigation

The app features a navigation rail with three sections:
1. **Home** (🏠): Original word pair generator
2. **Favorites** (❤️): Saved favorite word pairs
3. **AI Content** (✨): New content generation feature

## Content Generation Service

The `ContentGenerationService` provides:
- Mock content generation for demonstration
- Support for different tone and style combinations
- Extensible architecture for real AI API integration
- Error handling and async operation support

### Real AI Integration

To integrate with actual AI services (like OpenAI), update the `ContentGenerationService`:

1. Add your API key
2. Uncomment and modify the `_callActualAPI` method
3. Replace the mock content generation with actual API calls

## Usage

1. Navigate to the AI Content section
2. Enter keywords or themes
3. Select desired tone (Professional/Humorous/Casual)
4. Select desired style (Concise/Detailed)
5. Add optional additional instructions
6. Click "Generate Content"
7. Copy the generated content or generate new variations

## Testing

Run tests with:
```bash
flutter test
```

The project includes:
- Widget tests for the main application
- Unit tests for content generation models and services

## Dependencies

- `flutter`: UI framework
- `provider`: State management
- `english_words`: Word pair generation
- `http`: HTTP requests for AI services (future use)

## Getting Started

This project is a starting point for a Flutter application with AI content generation capabilities.

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application
4. Navigate to the AI Content section to try the new feature

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
