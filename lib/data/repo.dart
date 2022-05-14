import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/app/core/config.dart';
import 'package:doko_app/data/models/category_model.dart';
import 'package:doko_app/data/models/order_list_model.dart';
import 'package:doko_app/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  Future<List<ProductModel>> getProducts() async {
    final List data = await ApiClient().getData(endpoint: Config.product);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> getCategory() async {
    final List data = await ApiClient().getData(endpoint: Config.categories);
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<OrderListModel>> getOrderList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int userid = _prefs.getInt('userid')!;
    final List data = await ApiClient().getData(endpoint: "list-order");
    List<OrderListModel> orders =
        data.map((e) => OrderListModel.fromJson(e)).toList();
    return orders.where((element) => element.userId == userid).toList();
  }

  Future<List<OrderListModel>> getAllOrders() async {
    final List data = await ApiClient().getData(endpoint: "list-order");
    List<OrderListModel> orders =
        data.map((e) => OrderListModel.fromJson(e)).toList();
    return orders;
  }
}
