class ProductModel {
  final String name;
  final String category;

  ProductModel({this.name, this.category});

  Map<String, Object> toJson() {
    return {
      'name': name,
      'category': category,
    };
  }

  factory ProductModel.fromJson(Map<String, Object> doc) {
    return ProductModel(
      name: doc['name'],
      category: doc['category'],
    );
  }
}
