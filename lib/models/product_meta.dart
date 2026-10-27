class ProductMeta {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String barcode;
  final String qrCode;

  const ProductMeta({
    this.createdAt,
    this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory ProductMeta.fromJson(Map<String, Object?> json) {
    final createdRaw = json['createdAt'] as String?;
    final updatedRaw = json['updatedAt'] as String?;
    return ProductMeta(
      createdAt: createdRaw != null ? DateTime.tryParse(createdRaw) : null,
      updatedAt: updatedRaw != null ? DateTime.tryParse(updatedRaw) : null,
      barcode: (json['barcode'] as String?) ?? '',
      qrCode: (json['qrCode'] as String?) ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }
}