enum PostTargetType {
  wall,
  story,
  page,
}

class PostTarget {
  final String id;
  final String name;
  final PostTargetType type;
  final String? description;
  final bool hasPermission;

  const PostTarget({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.hasPermission = false,
  });

  @override
  String toString() {
    return 'PostTarget(id: $id, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostTarget && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}