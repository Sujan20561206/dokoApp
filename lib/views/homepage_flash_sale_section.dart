import 'package:carousel_slider/carousel_slider.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashSaleSection extends ConsumerWidget {
  const FlashSaleSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productData = ref.watch(productListProvider);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: const Text(
                  "Products",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          productData.when(
              error: (err, s) => Text(err.toString()),
              loading: () => const CircularProgressIndicator(),
              data: (_data) {
                return Column(children: [
                  CarouselSlider(
                    items: [
                      ..._data.map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ProductDetailPage(
                                          product: e,
                                        ))));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade900
                                ],
                              ),
                            ),
                            // color: Colors.blue.withOpacity(0.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    e.productName,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  e.categoryId.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                                Container(
                                    height: 160,
                                    width: 200,
                                    margin: const EdgeInsets.all(4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.horizontal(),
                                            image: DecorationImage(
                                                image: NetworkImage(e.image)),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Rs ${e.prevviousPrice}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text(
                                          'Rs ${e.currentPrice}',
                                          style: const TextStyle(
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                    options: CarouselOptions(
                        enlargeCenterPage: false,
                        viewportFraction: 0.4,
                        autoPlay: true,
                        autoPlayInterval: const Duration(milliseconds: 3000),
                        height: 240,
                        onPageChanged: (int index, reason) {}),
                  ),
                ]);
              })
        ],
      ),
    );
  }
}
