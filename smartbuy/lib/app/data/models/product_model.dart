class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final int stock;
  final String? image;
  final List<String>? images;
  final int categoryId;
  final String? categoryName;
  final double? rating;
  final int? reviewsCount;
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.stock,
    this.image,
    this.images,
    required this.categoryId,
    this.categoryName,
    this.rating,
    this.reviewsCount,
    this.isFeatured = false,
    this.isNewArrival = false,
    this.isBestSeller = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      stock: json['stock'] as int,
      image: json['image'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewsCount: json['reviews_count'] as int?,
      isFeatured: json['is_featured'] as bool? ?? false,
      isNewArrival: json['is_new_arrival'] as bool? ?? false,
      isBestSeller: json['is_best_seller'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'stock': stock,
      'image': image,
      'images': images,
      'category_id': categoryId,
      'category_name': categoryName,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_featured': isFeatured,
      'is_new_arrival': isNewArrival,
      'is_best_seller': isBestSeller,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get finalPrice => discountPrice ?? price;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountPrice!) / price) * 100;
  }

  bool get isInStock => stock > 0;

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    int? stock,
    String? image,
    List<String>? images,
    int? categoryId,
    String? categoryName,
    double? rating,
    int? reviewsCount,
    bool? isFeatured,
    bool? isNewArrival,
    bool? isBestSeller,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
