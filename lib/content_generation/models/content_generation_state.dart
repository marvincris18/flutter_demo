import 'package:flutter/material.dart';
import '../models/content_request.dart';
import '../models/generated_content.dart';
import '../services/content_generation_service.dart';

class ContentGenerationState extends ChangeNotifier {
  final ContentGenerationService _service = ContentGenerationService();
  
  ContentTone _selectedTone = ContentTone.professional;
  ContentStyle _selectedStyle = ContentStyle.concise;
  String _keywords = '';
  String _additionalInstructions = '';
  
  bool _isLoading = false;
  GeneratedContent? _lastGeneratedContent;
  String? _error;
  
  List<GeneratedContent> _history = [];

  // Getters
  ContentTone get selectedTone => _selectedTone;
  ContentStyle get selectedStyle => _selectedStyle;
  String get keywords => _keywords;
  String get additionalInstructions => _additionalInstructions;
  bool get isLoading => _isLoading;
  GeneratedContent? get lastGeneratedContent => _lastGeneratedContent;
  String? get error => _error;
  List<GeneratedContent> get history => List.unmodifiable(_history);

  // Setters
  void setTone(ContentTone tone) {
    _selectedTone = tone;
    notifyListeners();
  }

  void setStyle(ContentStyle style) {
    _selectedStyle = style;
    notifyListeners();
  }

  void setKeywords(String keywords) {
    _keywords = keywords;
    notifyListeners();
  }

  void setAdditionalInstructions(String instructions) {
    _additionalInstructions = instructions;
    notifyListeners();
  }

  // Actions
  Future<void> generateContent() async {
    if (_keywords.trim().isEmpty) {
      _error = 'Please enter keywords or themes for content generation';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = ContentRequest(
        keywords: _keywords,
        tone: _selectedTone,
        style: _selectedStyle,
        additionalInstructions: _additionalInstructions.isNotEmpty ? _additionalInstructions : null,
      );

      final content = await _service.generateContent(request);
      _lastGeneratedContent = content;
      _history.insert(0, content); // Add to beginning of list
      
      // Keep only last 10 items in history
      if (_history.length > 10) {
        _history = _history.take(10).toList();
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to generate content: ${e.toString()}';
      _lastGeneratedContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  void removeFromHistory(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      notifyListeners();
    }
  }
}