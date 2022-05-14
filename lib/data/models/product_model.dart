class ProductModel {
  ProductModel({
    required this.productName,
    required this.categoryId,
    required this.shortDescription,
    required this.description,
    required this.currentPrice,
    required this.prevviousPrice,
    required this.image,
    required this.productId,
    required this.quantity,
  });

  int productId;
  String productName;
  int categoryId;
  String shortDescription;
  String description;
  int currentPrice;
  int prevviousPrice;
  String image;
  int quantity;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      productName: json["product_name"],
      categoryId: json["category_id"],
      shortDescription: json["short_description"],
      description: json["description"],
      currentPrice: json["current_price"],
      prevviousPrice: json["prevvious_price"],
      image: json["image"],
      quantity: json["product_quantity"],
      productId: json["product_id"]);

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "category_id": categoryId,
        "short_description": shortDescription,
        "description": description,
        "current_price": currentPrice,
        "prevvious_price": prevviousPrice,
        "image": image,
      };
}
