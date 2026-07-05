class Product {
  final String id;
  final String name;
  final String description;
  final int price; // en FCFA
  final String imageUrl;
  final String category;
  final bool available;
  final bool isPromo;
  final int? promoPrice;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.available = true,
    this.isPromo = false,
    this.promoPrice,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0) as int,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      available: map['available'] ?? true,
      isPromo: map['isPromo'] ?? false,
      promoPrice: map['promoPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'available': available,
      'isPromo': isPromo,
      'promoPrice': promoPrice,
    };
  }
}
