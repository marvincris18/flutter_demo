import 'package:flutter/material.dart';
import '../models/content_request.dart';

class ToneSelector extends StatelessWidget {
  final ContentTone selectedTone;
  final Function(ContentTone) onToneChanged;

  const ToneSelector({
    super.key,
    required this.selectedTone,
    required this.onToneChanged,
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
                Icon(Icons.mood, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Tone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...ContentTone.values.map((tone) => _buildToneOption(context, tone)),
          ],
        ),
      ),
    );
  }

  Widget _buildToneOption(BuildContext context, ContentTone tone) {
    final isSelected = selectedTone == tone;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => onToneChanged(tone),
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
                _getToneIcon(tone),
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
                      _getToneTitle(tone),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getToneDescription(tone),
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

  IconData _getToneIcon(ContentTone tone) {
    switch (tone) {
      case ContentTone.professional:
        return Icons.business;
      case ContentTone.humorous:
        return Icons.sentiment_very_satisfied;
      case ContentTone.casual:
        return Icons.chat;
    }
  }

  String _getToneTitle(ContentTone tone) {
    switch (tone) {
      case ContentTone.professional:
        return 'Professional';
      case ContentTone.humorous:
        return 'Humorous';
      case ContentTone.casual:
        return 'Casual';
    }
  }

  String _getToneDescription(ContentTone tone) {
    switch (tone) {
      case ContentTone.professional:
        return 'Formal and business-appropriate';
      case ContentTone.humorous:
        return 'Light-hearted and entertaining';
      case ContentTone.casual:
        return 'Relaxed and conversational';
    }
  }
}