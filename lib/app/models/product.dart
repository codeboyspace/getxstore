class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.reviews,
  });

  double get mrp {
    final multiplier = 1 - (discountPercentage / 100);
    if (multiplier <= 0) return price;
    return price / multiplier;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      price: _parseDouble(json['price'] * 96.75),
      discountPercentage: _parseDouble(json['discountPercentage']),
      rating: _parseDouble(json['rating']),
      stock: (json['stock'] is int)
          ? json['stock'] as int
          : int.tryParse('${json['stock']}') ?? 0,
      brand: (json['brand'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? '').toString(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toStorageMap() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'brand': brand,
    'thumbnail': thumbnail,
    'images': images,
    'reviews': reviews.map((review) => review.toStorageMap()).toList(),
  };

  factory Product.fromStorageMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      price: _parseDouble(map['price']),
      discountPercentage: _parseDouble(map['discountPercentage']),
      rating: _parseDouble(map['rating']),
      stock: map['stock'] as int,
      brand: map['brand'] as String,
      thumbnail: map['thumbnail'] as String,
      images: (map['images'] as List<dynamic>).cast<String>(),
      reviews: (map['reviews'] as List<dynamic>)
          .map(
            (review) => Review.fromJson(Map<String, dynamic>.from(review as Map)),
          )
          .toList(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class Review {
  final double rating;
  final String comment;
  final String reviewerName;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: Product._parseDouble(json['rating']),
      comment: (json['comment'] ?? '').toString(),
      reviewerName: (json['reviewerName'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toStorageMap() => {
    'rating': rating,
    'comment': comment,
    'reviewerName': reviewerName,
  };
}
