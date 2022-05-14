import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:doko_app/app/core/api_client.dart';
import 'package:doko_app/app/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? file;
  @override
  Widget build(BuildContext context) {
    final _profile = ref.watch(profileProvider);
    final nameController = TextEditingController();
    final _addressController = TextEditingController();
    final _emailController = TextEditingController();
    final _contactController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: _profile.when(
            data: (data) {
              nameController.text = data.name;
              _emailController.text = data.email;
              _addressController.text = data.address;
              _contactController.text = data.contact;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    file == null
                        ? CachedNetworkImage(
                            height: 200,
                            imageUrl: data.profile,
                            errorWidget: (context, err, data) {
                              return const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png"));
                            },
                          )
                        : Image.file(
                            file!,
                            height: 200,
                          ),
                    OutlinedButton(
                        onPressed: () async {
                          var image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              file = File(image.path);
                            });
                          }
                        },
                        child: const Text("Edit image")),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _contactController,
                        decoration: const InputDecoration(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    file == null
                        ? OutlinedButton(
                            onPressed: () async {
                              final _prefs =
                                  await SharedPreferences.getInstance();
                              final int userid = _prefs.getInt('userid')!;
                              log(userid.toString());
                              final result = await ApiClient().postData(data: {
                                "name": nameController.text,
                                "email": _emailController.text,
                                "address": _addressController.text,
                                "contact": _contactController.text,
                              }, endpoint: "update-user-profile/$userid");
                              log(result.toString());
                              ref.refresh(profileProvider);
                            },
                            child: const Text("Update Profile"))
                        : OutlinedButton(
                            onPressed: () async {
                              final _prefs =
                                  await SharedPreferences.getInstance();
                              final int userid = _prefs.getInt('userid')!;
                              final multipartfile =
                                  await MultipartFile.fromFile(file!.path);
                              final FormData formData = FormData.fromMap({
                                "name": nameController.text,
                                "email": _emailController.text,
                                "address": _addressController.text,
                                "contact": _contactController.text,
                                "profile": multipartfile
                              });
                              final result = await ApiClient().postData(
                                  data: formData,
                                  endpoint: "update-user-profile/$userid");
                              ref.refresh(profileProvider);
                              log(result.toString());
                            },
                            child: const Text("Update Profile"))
                  ],
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
      ),
    );
  }
}
