class ProductReview {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ProductReview.fromJson(Map<String, Object?> json) {
    final rawDate = json['date'] as String?;
    return ProductReview(
      rating: (json['rating'] as num?)?.round() ?? 5,
      comment: (json['comment'] as String?) ?? '',
      date: (rawDate != null ? DateTime.tryParse(rawDate) : null) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      reviewerName: (json['reviewerName'] as String?) ?? 'Anonymous',
      reviewerEmail: (json['reviewerEmail'] as String?) ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}