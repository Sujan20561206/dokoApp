import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/add_product_page.dart';
import 'package:doko_app/views/product_detail_page.dart';
import 'package:doko_app/views/product_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminProductPage extends ConsumerStatefulWidget {
  const AdminProductPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminProductPageState();
}

class _AdminProductPageState extends ConsumerState<AdminProductPage> {
  @override
  Widget build(BuildContext context) {
    final _products = ref.watch(productListProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
              onPressed: () {
                ref.refresh(productListProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: _products.when(
          data: (_data) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                children: [
                  ..._data.map(
                    (e) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                      product: e,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.1), //color of shadow
                              spreadRadius: 2, //spread radius
                              blurRadius: 2, // blur radius
                              offset: const Offset(-2, 0),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(e.image)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 12, top: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.productName.toUpperCase(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    e.categoryId.toString(),
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    e.currentPrice.toString(),
                                    style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ProductEditPage(
                                                    product: e,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text("Edit"))),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                primary: Colors.red),
                                            onPressed: () async {
                                              // product delete (ctrl+deleteProduct)
                                              await ApiClient().deleteProduct(
                                                  productId: e.productId);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Product deleted successfully"),
                                              ));
                                              ref.refresh(productListProvider);
                                            },
                                            child: const Text("Delete"))),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (err, s) => Text(err.toString()),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
