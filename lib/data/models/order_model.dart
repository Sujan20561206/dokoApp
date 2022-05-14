class OrderModel {
  OrderModel(
      {required this.productId,
      this.orderId,
      required this.userId,
      required this.shippingAddress,
      required this.billingAddress,
      required this.quantity,
      required this.status,
      required this.total,
      this.name = '',
      this.totalQuantity = 1,
      this.currentPrice});

  final String productId;
  final String? orderId;
  final String userId;
  final String shippingAddress;
  final String billingAddress;
  int quantity;
  int totalQuantity;
  final String status;
  String total;
  final String name;
  int? currentPrice;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        name: '',
        productId: json["product_id"],
        orderId: json["order_id"],
        userId: json["user_id"],
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
        quantity: json["quantity"],
        status: json["status"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "order_id": orderId,
        "user_id": userId,
        "shipping_address": shippingAddress,
        "billing_address": billingAddress,
        "quantity": quantity,
        "status": status,
        "total": total,
      };
}
