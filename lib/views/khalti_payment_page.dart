import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/data/models/order_model.dart';
import 'package:doko_app/views/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/core/api_client.dart';

class KhaltiPaymentPage extends StatefulWidget {
  const KhaltiPaymentPage({Key? key, required this.orders}) : super(key: key);
  final List<OrderModel> orders;

  @override
  State<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

class _KhaltiPaymentPageState extends State<KhaltiPaymentPage> {
  // whole order ko total price calculate
  getTotal() {
    int sum = 0;
    for (int i = 0; i < widget.orders.length; i++) {
      sum += int.parse(widget.orders[i].total);
    }
    return sum.toString();
  }

  TextEditingController amountController = TextEditingController();

  getAmt() {
    return int.parse(amountController.text) * 100; // Converting to paisa
  }

  @override
  Widget build(BuildContext context) {
    amountController.text = getTotal();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment Integration'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            // For Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Enter Amount to pay",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            //
            // For Button
            Consumer(builder: (context, ref, child) {
              return MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.red)),
                  height: 50,
                  color: const Color(0xFF56328c),
                  child: const Text(
                    'Pay With Khalti',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  onPressed: () {
                    KhaltiScope.of(context).pay(
                      config: PaymentConfig(
                        amount: getAmt(),
                        productIdentity: 'dells-sssssg5-g5510-2021',
                        productName: 'Product Name',
                      ),
                      preferences: [
                        PaymentPreference.khalti,
                      ],
                      onSuccess: (su) async {
                        const successsnackBar = SnackBar(
                          content: Text('Payment Successful'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(successsnackBar);
                        await ApiClient().placeOrder(orders: widget.orders);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Order placed successfully")));
                        ref.watch(cartProvider.notifier).state.clear();
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();

                        Navigator.of(context)
                            .pushReplacement(CupertinoPageRoute(
                                builder: (context) => Homepage(
                                      role: _prefs.getString("role")!,
                                    )));
                      },
                      onFailure: (fa) {
                        const failedsnackBar = SnackBar(
                          content: Text('Payment Failed'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(failedsnackBar);
                      },
                      onCancel: () {
                        const cancelsnackBar = SnackBar(
                          content: Text('Payment Cancelled'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(cancelsnackBar);
                      },
                    );
                  });
            })
          ],
        ),
      ),
    );
  }
}
