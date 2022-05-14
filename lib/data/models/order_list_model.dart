class OrderListModel {
  OrderListModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.orderId,
    required this.shippingAddress,
    required this.billingAddress,
    required this.status,
    required this.total,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int productId;
  int userId;
  String orderId;
  String shippingAddress;
  String billingAddress;
  String status;
  String total;
  String quantity;
  DateTime createdAt;
  DateTime updatedAt;

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
        status: json["status"],
        total: json["total"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "order_id": orderId,
        "shipping_address": shippingAddress,
        "billing_address": billingAddress,
        "status": status,
        "total": total,
        "quantity": quantity,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
