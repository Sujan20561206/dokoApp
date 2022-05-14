import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    final _categories = ref.watch(categoriesProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: "Enter category name"),
                  ),
                ),
                OutlinedButton(
                    onPressed: () async {
                      await ApiClient().postData(
                          data: {"cat_name": controller.text},
                          endpoint: "categories");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Category added")));
                      ref.refresh(categoriesProvider);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add category"))
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.refresh(categoriesProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text('Categories'),
      ),
      body: _categories.when(
          data: (_data) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ..._data.map((e) => ListTile(
                        title: Text(e.name),
                        subtitle: Text("id : ${e.id}"),
                        trailing: IconButton(
                          onPressed: () async {
                            await ApiClient().deleteCategory(categoryId: e.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Product deleted successfully")));
                            ref.refresh(categoriesProvider);
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      )),
                ],
              ),
            );
          },
          error: (err, s) => Center(
                child: Text(err.toString()),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
