import 'dart:developer';

import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/data/models/order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  bool ascending = false;
  bool filter = false;
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    final _orders = ref.watch(allorderProviderProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order list page"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  filter = false;
                  selectedDate = null;
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: _orders.when(
          data: (_data) {
            List<OrderListModel> newList = _data;
            var formatter = DateFormat('yyyy-MM-dd');
            if (filter = true && selectedDate != null) {
              newList = _data
                  .where((element) =>
                      formatter.format(element.createdAt) ==
                      formatter.format(selectedDate!))
                  .toList();
            }
            // newest ra oldest sorting asending descending
            ascending
                ? newList.sort((a, b) => a.createdAt.compareTo(b.createdAt))
                : newList.sort((b, a) => a.createdAt.compareTo(b.createdAt));
            return RefreshIndicator(
              onRefresh: () async {
                ref.refresh(orderProvider);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: () async {
                              // calendar kholni admin lai
                              final DateTime? selected = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(3025));
                              if (selected != null) {
                                setState(() {
                                  selectedDate = selected;
                                  filter = true;
                                });
                                log(selectedDate.toString());
                              }
                            },
                            child: const Text("Choose date")),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                ascending = true;
                              });
                            },
                            child: const Text(
                              "Oldest orders first",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.green),
                            )),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                ascending = false;
                              });
                            },
                            child: const Text(
                              "Newest orders first",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.green),
                            ))
                      ],
                    ),
                    ...newList.map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderCardRow(
                                      name: 'Order id', value: e.orderId),
                                  OrderCardRow(
                                      name: 'Product id',
                                      value: e.productId.toString()),
                                  OrderCardRow(
                                      name: 'Quantity', value: e.quantity),
                                  OrderCardRow(
                                      name: 'Shipping address',
                                      value: e.shippingAddress),
                                  OrderCardRow(
                                      name: 'Billing address',
                                      value: e.billingAddress),
                                  OrderCardRow(
                                      name: 'User id',
                                      value: e.userId.toString()),
                                  OrderCardRow(name: 'Status', value: e.status),
                                  OrderCardRow(
                                      name: 'Order date',
                                      value: DateFormat.yMMMMEEEEd()
                                          .format(e.createdAt)),
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
          error: (err, s) => Text(err.toString()),
          loading: () => const CircularProgressIndicator()),
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
          width: 100,
          child: Text(
            '$name :',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 220,
          child: Text(value),
        ),
      ],
    );
  }
}
