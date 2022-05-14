import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/data/models/product_model.dart';
import 'package:doko_app/views/cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/order_model.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => const CartPage()));
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                ),
              ]),
          body: ListView(
            children: [
              Container(
                height: 300,
                margin:
                    const EdgeInsets.only(left: 6, right: 6, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  image: DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset.zero,
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                width: double.infinity,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Rs ${product.currentPrice}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(product.productName),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Short Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        product.shortDescription,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  )),
              BottomNav(detail: product)
            ],
          )),
    );
  }
}

final quantityProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({
    Key? key,
    required this.detail,
  }) : super(key: key);
  final ProductModel detail;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final _quantity = ref.watch(quantityProvider);
    List<String> idList =
        ref.watch(cartProvider.notifier).state.map((e) => e.productId).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!idList.contains(widget.detail.productId.toString()))
              IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      ref.watch(quantityProvider.notifier).state--;
                    }
                  },
                  icon: const Icon(Icons.remove)),
            if (!idList.contains(widget.detail.productId.toString()))
              Text(_quantity.toString()),
            if (!idList.contains(widget.detail.productId.toString()))
              IconButton(
                  onPressed: () {
                    _quantity >= widget.detail.quantity
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Cannot add more"),
                            ),
                          )
                        : ref.watch(quantityProvider.notifier).state++;
                  },
                  icon: const Icon(Icons.add)),
            idList.contains(widget.detail.productId.toString())
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => const CartPage()));
                    },
                    child: const Text("Goto Cart"))
                : ElevatedButton(
                    onPressed: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      ref.read(cartProvider.notifier).state.add(OrderModel(
                            name: widget.detail.productName,
                            shippingAddress: "",
                            productId: widget.detail.productId.toString(),
                            userId: _prefs.getInt('userid').toString(),
                            billingAddress: "",
                            quantity: _quantity,
                            totalQuantity: widget.detail.quantity,
                            total: (_quantity * widget.detail.currentPrice)
                                .toString(),
                            status: "unpaid",
                            currentPrice: widget.detail.currentPrice,
                          ));
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Product added to cart"),
                        ),
                      );
                    },
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text("Available quantity : ${widget.detail.quantity}")
      ],
    );
  }
}
