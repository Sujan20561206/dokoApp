import 'package:doko_app/app/core/providers.dart';
import 'package:doko_app/views/admin_product_page.dart';
import 'package:doko_app/views/cart_page.dart';
import 'package:doko_app/views/category_page.dart';
import 'package:doko_app/views/login_page.dart';
import 'package:doko_app/views/my_order_list_page.dart';
import 'package:doko_app/views/adminOrder_list_page.dart';
import 'package:doko_app/views/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage_FeaturedProducts.dart';
import 'homepage_category.dart';
import 'homepage_Products.dart';

class Homepage extends ConsumerWidget {
  const Homepage({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _profile = ref.watch(profileProvider);
    return SafeArea(
      child: Scaffold(
        drawer: role == "user"
            ? null
            : Drawer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    // role admin cha bhaney
                    if (role == "admin")
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminProductPage()));
                        },
                        title: const Text("Products"),
                      ),
                    if (role == "admin")
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const OrderListPage()));
                        },
                        title: const Text("See all orders"),
                      ),
                    if (role == "admin")
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CategoryPage()));
                        },
                        title: const Text("See all categories"),
                      )
                  ],
                ),
              ),
        appBar: AppBar(
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (role == "user")
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyOrderListPage()));
                        },
                        child: const Text(
                          "My order history",
                          style: TextStyle(color: Colors.white),
                        )),
                  const SizedBox(width: 10),
                  _profile.when(
                      data: (data) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(data.profile),
                          ),
                        );
                      },
                      error: (err, s) {
                        return const CircleAvatar(
                          backgroundColor: Colors.white,
                        );
                      },
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          )),
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, top: 2),
                      child: Stack(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 16,
                            ),
                          ),
                          // if (_cartList.isNotEmpty)
                        ],
                      ),
                    ),

                    // const Icon(
                    //   Icons.shopping_cart_outlined,
                    // ),
                  ),
                  GestureDetector(
                    // logout huncha ani login page ma jancha
                    onTap: () async {
                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      _prefs.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false);
                    },
                    child: const Padding(
                        padding: EdgeInsets.only(
                          top: 4,
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 20,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(productListProvider);
          },
          child: ListView(
            shrinkWrap: true,
            children: const [
              // SearchWidget(),
              FeaturedProductsSection(),
              CategoriesSection(),
              HomepageProducts(),
              // RecomendedSection()
            ],
          ),
        ),
      ),
    );
  }
}
