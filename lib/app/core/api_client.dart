import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doko_app/app/core/config.dart';
import 'package:doko_app/data/models/ptofile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/order_model.dart';

class ApiClient {
  Future<ProfileModel> getProfile() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString("token");
    var userid = _prefs.getInt("userid");
    final result = await Dio(BaseOptions(
            baseUrl: Config.baseUrl,
            headers: {"Authorization": "Bearer $token"}))
        .get("user-profile/$userid");
    return ProfileModel.fromMap(result.data[0]);
  }

  Future getData({required String endpoint}) async {
    final result =
        await Dio(BaseOptions(baseUrl: Config.baseUrl)).get(endpoint);
    return result.data;
  }

  Future postData({required data, required String endpoint}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString("token");
    final result = await Dio(BaseOptions(
            baseUrl: Config.baseUrl,
            headers: {"Authorization": "Bearer $token"}))
        .post(endpoint, data: data);

    return result.data;
  }

  Future deleteCategory({required int categoryId}) async {
    await Dio(BaseOptions(baseUrl: Config.baseUrl))
        .delete("categories/$categoryId");
  }

  Future deleteProduct({required int productId}) async {
    await Dio(BaseOptions(baseUrl: Config.baseUrl))
        .delete("products/$productId");
  }

  Future updateProduct(
      {required Map<String, dynamic> data, required int id}) async {
    final result = await Dio(BaseOptions(baseUrl: Config.baseUrl))
        .post('products/$id', data: data);
    log(result.data.toString());
  }

  Future signUp({required Map<String, dynamic> data}) async {
    final result = await Dio(BaseOptions(baseUrl: Config.baseUrl))
        .post('register', data: data);
    log(result.data.toString());
    if (result.data["validation_error"] == null) {
      return "success";
    } else {
      return "fail";
    }
  }

  Future login({required Map<String, dynamic> data}) async {
    final result = await Dio(BaseOptions(baseUrl: Config.baseUrl))
        .post('login', data: data);
    log(result.data.toString());
    if (result.data["status"] == 401) {
      return "fail";
    } else {
      return {
        "userid": result.data["data"]["id"],
        "role": result.data["data"]["role"],
        "token": result.data["token"]
      };
    }
  }

  Future placeOrder({required List<OrderModel> orders}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final List<OrderModel> sendOrders = orders
        .map((e) => OrderModel(
            shippingAddress: e.shippingAddress,
            billingAddress: e.billingAddress,
            productId: e.productId,
            userId: _prefs.getInt('userid').toString(),
            status: e.status,
            total: e.total,
            quantity: e.quantity))
        .toList();
    Dio _dio = Dio(BaseOptions(headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    }));

    for (int i = 0; i < sendOrders.length; i++) {
      await _dio.post(Config.baseUrl + "order", data: sendOrders[i].toJson());
    }
  }
}
