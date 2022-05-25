import 'package:carousel_slider/carousel_slider.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _category = ref.watch(productListProvider);
      return _category.when(
          data: (_data) => Container(
                margin: const EdgeInsets.only(
                  bottom: 4,
                  top: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: const Text(
                            "Featured Products",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          items: [
                            ..._data.map(
                              (e) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => ProductDetailPage(
                                                  product: e,
                                                )));
                                  },
                                  child: Image.network(e.image)),
                            )
                          ],
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval:
                                  const Duration(milliseconds: 3000),
                              height: 200,
                              onPageChanged: (int index, reason) {}),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          error: (error, s) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()));
    });
  }
}
