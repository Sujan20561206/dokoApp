import 'package:doko_app/views/chekout_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/core/providers.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    final _products = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text("Cart is empty"),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                onPressed: () {
                                  ref.refresh(cartProvider);
                                },
                                child: const Text("Clear cart")),
                          ),
                        ),
                      ],
                    ),
                    ..._products.map((e) => Card(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    OrderCardRow(name: 'Name', value: e.name),
                                    OrderCardRow(
                                        name: 'Product id', value: e.productId),
                                    OrderCardRow(
                                        name: 'Quantity',
                                        value: e.quantity.toString()),
                                    OrderCardRow(
                                        name: 'Total price',
                                        value: "Rs. ${e.total}"),
                                    SizedBox(
                                      width: 260,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (_products[_products
                                                            .indexOf(e)]
                                                        .quantity !=
                                                    1) {
                                                  ref
                                                      .watch(
                                                          cartProvider.notifier)
                                                      .state[
                                                          _products.indexOf(e)]
                                                      .quantity--;
                                                }
                                                setState(() {
                                                  _products[
                                                          _products.indexOf(e)]
                                                      .total = (e.quantity *
                                                          e.currentPrice!)
                                                      .toString();
                                                });
                                              },
                                              icon: const Icon(Icons.remove)),
                                          Text(_products[_products.indexOf(e)]
                                              .quantity
                                              .toString()),
                                          IconButton(
                                              onPressed: () {
                                                if (_products[_products
                                                            .indexOf(e)]
                                                        .quantity <
                                                    _products[_products
                                                            .indexOf(e)]
                                                        .totalQuantity) {
                                                  ref
                                                      .watch(
                                                          cartProvider.notifier)
                                                      .state[
                                                          _products.indexOf(e)]
                                                      .quantity++;
                                                }
                                                setState(() {
                                                  _products[
                                                          _products.indexOf(e)]
                                                      .total = (e.quantity *
                                                          e.currentPrice!)
                                                      .toString();
                                                });
                                              },
                                              icon: const Icon(Icons.add))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref.watch(cartProvider.notifier).state = [
                                    ..._products..remove(e)
                                  ];
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Item removed")));
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => CheckoutPage(
                                  orders: _products,
                                )));
                      },
                      child: const Text("Proceed to checkout")),
                )
              ],
            ),
    );
  }
}

class OrderCardRow extends StatelessWidget {
  const OrderCardRow({Key? key, required this.name, required this.value})
      : super(key: key);
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$name :',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(value),
        ),
      ],
    );
  }
}
