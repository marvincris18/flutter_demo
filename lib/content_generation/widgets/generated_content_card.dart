import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/generated_content.dart';

class GeneratedContentCard extends StatelessWidget {
  final GeneratedContent content;
  final bool isLatest;
  final VoidCallback? onDelete;

  const GeneratedContentCard({
    super.key,
    required this.content,
    this.isLatest = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isLatest ? 4 : 2,
      color: isLatest ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildContent(context),
            const SizedBox(height: 16),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (isLatest) ...[
          Icon(
            Icons.new_releases,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Generated Content',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ] else ...[
          Icon(
            Icons.history,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Previous Generation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
        const Spacer(),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: SelectableText(
        content.content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildMetadataChip(Icons.search, 'Keywords: ${content.keywords}'),
            const SizedBox(width: 8),
            _buildMetadataChip(Icons.mood, 'Tone: ${content.tone}'),
            const SizedBox(width: 8),
            _buildMetadataChip(Icons.format_align_left, 'Style: ${content.style}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              _formatDateTime(content.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            _buildCopyButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildMetadataChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            iconSize: 20,
            color: Colors.grey[600],
            tooltip: 'Delete',
          ),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _copyToClipboard(context),
      icon: const Icon(Icons.copy, size: 16),
      label: const Text('Copy'),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: content.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}