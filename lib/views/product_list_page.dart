import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage(
      {Key? key, required this.categoryName, required this.categoryid})
      : super(key: key);
  final String categoryName;
  final String categoryid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.6;
    final double itemWidth = size.width * 0.5;
    final _products = ref.watch(productListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: _products.when(
          data: (_data) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.count(
                childAspectRatio: (itemWidth / itemHeight),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  ..._data
                      .where((element) =>
                          element.categoryId.toString() == categoryid)
                      .map(
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
                                  margin:
                                      const EdgeInsets.only(left: 12, top: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            fontSize: 9,
                                            color: Colors.grey[600]),
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
