class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
  });

  // JSON to flutter
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
      rating: json['rating'] != null ? json['rating']['rate'].toDouble() : 0.0,
    );
  }

  // obh to json map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
    };
  }
}