import 'package:flutter/material.dart';
import '../models/content_request.dart';

class StyleSelector extends StatelessWidget {
  final ContentStyle selectedStyle;
  final Function(ContentStyle) onStyleChanged;

  const StyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_align_left, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Style',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...ContentStyle.values.map((style) => _buildStyleOption(context, style)),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleOption(BuildContext context, ContentStyle style) {
    final isSelected = selectedStyle == style;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => onStyleChanged(style),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSelected 
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
            border: Border.all(
              color: isSelected 
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _getStyleIcon(style),
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStyleTitle(style),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getStyleDescription(style),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStyleIcon(ContentStyle style) {
    switch (style) {
      case ContentStyle.concise:
        return Icons.short_text;
      case ContentStyle.detailed:
        return Icons.article;
    }
  }

  String _getStyleTitle(ContentStyle style) {
    switch (style) {
      case ContentStyle.concise:
        return 'Concise';
      case ContentStyle.detailed:
        return 'Detailed';
    }
  }

  String _getStyleDescription(ContentStyle style) {
    switch (style) {
      case ContentStyle.concise:
        return 'Short and to the point';
      case ContentStyle.detailed:
        return 'Comprehensive and thorough';
    }
  }
}