class ChuckNorrisJoke {
  final String id;
  final String value;
  final List<String> categories;
  final String iconUrl;
  final String url;
  final String createdAt;
  final String updatedAt;

  ChuckNorrisJoke({
    required this.id,
    required this.value,
    required this.categories,
    required this.iconUrl,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChuckNorrisJoke.fromJson(Map<String, dynamic> json) {
    return ChuckNorrisJoke(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      iconUrl: json['icon_url'] ?? '',
      url: json['url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'categories': categories,
      'icon_url': iconUrl,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
