class ProductModel {
  String name;
  String category;

  ProductModel({this.name, this.category});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
      };
}
