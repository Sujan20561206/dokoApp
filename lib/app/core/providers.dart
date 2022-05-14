import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/data/models/category_model.dart';
import 'package:doko_app/data/models/order_list_model.dart';
import 'package:doko_app/data/models/order_model.dart';
import 'package:doko_app/data/models/product_model.dart';
import 'package:doko_app/data/models/ptofile_model.dart';
import 'package:doko_app/data/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productListProvider =
    FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  return Repository().getProducts();
});

final categoriesProvider =
    FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  return Repository().getCategory();
});

final cartProvider = StateProvider<List<OrderModel>>((ref) {
  return [];
});

final cartIdListProvider = StateProvider<List<String>>((ref) {
  return ref
      .watch(cartProvider.select((p) => p.map((e) => e.productId)))
      .toList();
});

final orderProvider =
    FutureProvider.autoDispose<List<OrderListModel>>((ref) async {
  return Repository().getOrderList();
});

final allorderProviderProvider =
    FutureProvider.autoDispose<List<OrderListModel>>((ref) async {
  return Repository().getAllOrders();
});

final profileProvider = FutureProvider.autoDispose<ProfileModel>((ref) async {
  return ApiClient().getProfile();
});
