import 'dart:developer';

import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product_model.dart';

class ProductEditPage extends ConsumerWidget {
  const ProductEditPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context, ref) {
    final TextEditingController nameController = TextEditingController();
    nameController.text = product.productName;
    final TextEditingController sDesController =
        TextEditingController(text: product.shortDescription);
    final TextEditingController desController =
        TextEditingController(text: product.description);
    final TextEditingController cPriceController =
        TextEditingController(text: product.currentPrice.toString());
    final TextEditingController pPriceController =
        TextEditingController(text: product.prevviousPrice.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                controller: sDesController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                controller: desController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: cPriceController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.blue.shade100,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: pPriceController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            OutlinedButton(
                onPressed: () async {
                  // product update(ctrl+updateProduct)
                  ApiClient().updateProduct(data: {
                    "name": nameController.text,
                    "short_description": sDesController.text,
                    "description": desController.text,
                    "current_price": cPriceController.text,
                    "previous_price": pPriceController.text
                  }, id: product.productId);
                  log(nameController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Product updated successfully"),
                  ));
                  Navigator.pop(context);
                  ref.refresh(productListProvider);
                },
                child: const Text("Update Product"))
          ],
        ),
      ),
    );
  }
}
