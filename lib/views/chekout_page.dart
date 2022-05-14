import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/data/models/order_model.dart';
import 'package:doko_app/views/khalti_payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key, required this.orders}) : super(key: key);
  final List<OrderModel> orders;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _loading = false;
  final TextEditingController shippingController =
      TextEditingController(text: "Pokhara");
  final TextEditingController billingController =
      TextEditingController(text: "Pokhara");
  final GlobalKey _scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: shippingController,
                      decoration: const InputDecoration(
                          label: Text("Shipping address"),
                          border: InputBorder.none,
                          hintText: "Pokhara"),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: billingController,
                      decoration: const InputDecoration(
                          label: Text("Billing address"),
                          border: InputBorder.none,
                          hintText: "Pokhara"),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            List<OrderModel> newOrders = widget.orders
                                .map((e) => OrderModel(
                                      shippingAddress: shippingController.text,
                                      billingAddress: billingController.text,
                                      userId: e.userId,
                                      productId: e.productId,
                                      quantity: e.quantity,
                                      total: e.total,
                                      status: "Unpaid: Cash on delivery",
                                    ))
                                .toList();
                            setState(() {
                              _loading = true;
                            });
                            await ApiClient().placeOrder(orders: newOrders);
                            ScaffoldMessenger.of(_scaffold.currentContext!)
                                .showSnackBar(const SnackBar(
                                    content:
                                        Text("Order placed successfully")));

                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();

                            Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                    builder: (context) => Homepage(
                                          role: _prefs.getString("role")!,
                                        )),
                                (route) => false);
                          },
                          child: const Text("Cash on delivery"),
                        ),
                  ElevatedButton(
                    onPressed: () {
                      List<OrderModel> newOrders = widget.orders
                          .map((e) => OrderModel(
                                shippingAddress: shippingController.text,
                                billingAddress: billingController.text,
                                userId: e.userId,
                                productId: e.productId,
                                quantity: e.quantity,
                                total: e.total,
                                status: "Paid : Via Khalti",
                              ))
                          .toList();
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => KhaltiPaymentPage(
                                orders: newOrders,
                              )));
                    },
                    child: const Text("Pay with Khalti"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
