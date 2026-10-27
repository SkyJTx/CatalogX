class ProductCategory {
  final String slug;
  final String name;
  final String url;

  const ProductCategory({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory ProductCategory.fromJson(Map<String, Object?> json) {
    final slug = (json['slug'] as String?) ?? '';
    return ProductCategory(
      slug: slug,
      name: (json['name'] as String?) ?? _formatSlug(slug),
      url: (json['url'] as String?) ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'slug': slug,
      'name': name,
      'url': url,
    };
  }

  static String _formatSlug(String raw) {
    if (raw.isEmpty) return '';
    return raw
        .split('-')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}