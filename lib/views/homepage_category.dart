import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/product_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _categoriesData = ref.watch(categoriesProvider);

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height) / 3.6;
    final double itemWidth = size.width * 0.6;

    return _categoriesData.when(
      data: (_data) {
        final _result = _data;
        return Container(
          margin: const EdgeInsets.only(
            bottom: 4,
            top: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 4,
                color: Colors.grey[200]!,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: const Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: GridView.count(
                  childAspectRatio: (itemWidth / itemHeight),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: [
                    ..._result.map(
                      (e) => Container(
                        margin: const EdgeInsets.all(3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => ProductListPage(
                                      categoryName: e.name,
                                      categoryid: e.id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 56,
                                width: 82,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(e.id == 4
                                        ? "https://i0.wp.com/onhike.com/wp-content/uploads/2021/07/buy-the-best-electronic-products-online.jpg?fit=680%2C408&ssl=1"
                                        : e.id == 5
                                            ? "https://thumbs.dreamstime.com/b/bottles-health-beauty-products-care-collection-face-body-isolated-white-35361945.jpg"
                                            : e.id == 6
                                                ? "https://blogs-images.forbes.com/veenamccoole/files/2018/12/TRUFFLE-Clarity-Jetset-Case_Lifestyle4-1200x800.jpg"
                                                : e.id == 7
                                                    ? "https://www.mansworldindia.com/wp-content/uploads/2019/04/sample1-1.jpg"
                                                    : e.id == 8
                                                        ? "https://media.istockphoto.com/photos/polka-dot-summer-brown-dress-suede-wedge-sandals-eco-straw-tote-bag-picture-id1208148708?k=20&m=1208148708&s=612x612&w=0&h=rjZiAPCOpwREiTET21lTP3wM30BUqAG9PjocC-euJ98="
                                                        : e.id == 9
                                                            ? "https://2.imimg.com/data2/DR/CR/MY-3998144/sports-products-500x500.jpg"
                                                            : e.id == 10
                                                                ? "https://aniportalimages.s3.amazonaws.com/media/details/leadjan132021lkjhgty.jpg"
                                                                : e.id == 11
                                                                    ? "https://i.pinimg.com/originals/59/01/3c/59013cc60410fed768da67c397a9c4c0.jpg"
                                                                    : e.id == 18
                                                                        ? "https://neostore.com.np/assets/uploads/uploads/2021/03/videocon_0023_Videocon-24DN5-CBU-NT-24inch-LED-TV.jpg"
                                                                        : "https://www.usa.philips.com/c-dam/b2c/category-pages/sound-and-vision/monitors/redesign/curved-monitors/346e2cuae-png.png"),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              e.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, s) => Text(error.toString()),
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GridView.count(
            childAspectRatio: (itemWidth / itemHeight),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  Text(
                    'he',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
