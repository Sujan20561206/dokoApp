import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doko_app/app/core/config.dart';
import 'package:doko_app/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool _loading = false;
  File? image;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController catIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController sDesController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController cPriceController = TextEditingController();
  final TextEditingController pPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _loading
          ? const Center(child: CircularProgressIndicator())
          : FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                String fileName = image!.path.split('/').last;
                FormData formData = FormData.fromMap({
                  "product_image": await MultipartFile.fromFile(image!.path,
                      filename: fileName),
                  "product_name": nameController.text,
                  "category_id": int.parse(catIdController.text),
                  "unit": "piece",
                  "short_description": sDesController.text,
                  "description": desController.text,
                  "current_price": int.parse(cPriceController.text),
                  "previous_price": int.parse(pPriceController.text),
                  "qunatity": int.parse(quantityController.text)
                });
                final response = await Dio(BaseOptions(baseUrl: Config.baseUrl))
                    .post("products", data: formData);
                log(response.data.toString());
                setState(() {
                  _loading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Successfully added product")));

                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Homepage(
                          role: _prefs.getString("role")!,
                        )));
              },
              child: const Icon(Icons.done),
            ),
      appBar: AppBar(
        title: const Text("Add product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Product name'),
              ),
              TextField(
                controller: catIdController,
                decoration: const InputDecoration(
                  hintText: 'Category id',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(hintText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: sDesController,
                decoration:
                    const InputDecoration(hintText: 'Short description'),
              ),
              TextField(
                controller: desController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              TextField(
                controller: cPriceController,
                decoration: const InputDecoration(hintText: 'Current price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: pPriceController,
                decoration: const InputDecoration(hintText: 'Previous price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 40,
              ),
              image == null
                  ? OutlinedButton(
                      onPressed: () async {
                        var imagePicker = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imagePicker != null) {
                          setState(() {
                            image = File(imagePicker.path);
                          });
                        }
                      },
                      child: const Text("Choose image"))
                  : Image.file(image!),
              // thumbnailImage.isEmpty
              //     ? OutlinedButton(
              //         onPressed: () async {
              //           XFile? image = await ImagePicker()
              //               .pickImage(source: ImageSource.gallery);
              //           var file = _io.File(image!.path).readAsBytesSync();
              //           var baseimage = base64.encode(file);
              //           setState(() {
              //             thumbnailImage = baseimage;
              //           });
              //         },
              //         child: const Text('Select thumbnail image'))
              //     : Image.memory(
              //         const Base64Decoder().convert(thumbnailImage),
              //       ),
              const SizedBox(
                height: 40,
              ),
              // gallery.isEmpty
              //     ? OutlinedButton(
              //         onPressed: () async {
              //           List<XFile>? images =
              //               await ImagePicker().pickMultiImage();
              //           final List<_io.File> _images =
              //               images!.map((e) => _io.File(e.path)).toList();
              //           final encodedImages = _images.map((e) {
              //             return _io.File(e.path).readAsBytesSync();
              //           }).toList();
              //           final baseImages = encodedImages
              //               .map(((e) => base64.encode(e)))
              //               .toList();

              //           setState(() {
              //             gallery = baseImages;
              //           });
              //         },
              //         child: const Text('Pick gallery images'))
              //     : GridView(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         gridDelegate:
              //             const SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 2,
              //           mainAxisSpacing: 16.0,
              //           crossAxisSpacing: 16.0,
              //         ),
              //         children: [
              //           ...gallery.map(
              //             (e) => Image.memory(
              //               const Base64Decoder().convert(e),
              //               fit: BoxFit.cover,
              //             ),
              //           )
              //         ],
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
