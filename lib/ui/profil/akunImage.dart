// import 'dart:html';

// ignore_for_file: unused_field, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/services/apiStatic.dart';
import 'package:flutter_pembukuan/ui/landing.dart';
import 'package:flutter_pembukuan/ui/profil/imageController.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AkunImage extends StatefulWidget {
  const AkunImage({super.key});

  @override
  State<AkunImage> createState() => _AkunImageState();
}

class _AkunImageState extends State<AkunImage> {
  String id = '';
  String token = '';
  String urlServer = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getIdUser().then((v) => id = v.toString());
    SharedLogin.getToken().then((v) => token = v);
    urlServer = ApiStatic.urlServer;
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ImageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unggah Foto'),
        // centerTitle: mounted,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
            ),
            image: DecorationImage(
              image: AssetImage('assets/appbar/pattern.png'),
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ImageController>(builder: (imageCtrl) {
          return Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(children: [
                const SizedBox(height: 35),
                InkWell(
                  highlightColor: Colors.purple.withOpacity(0.3),
                  splashColor: Colors.pink.withOpacity(0.5),
                  onTap: () {
                    imageCtrl.pickImage();
                    Get.find<ImageController>().setNull('set null');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 300,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.pink),
                    ),
                    child: imageCtrl.pickedFile != null
                        ? Image.file(
                            File(imageCtrl.pickedFile!.path),
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : const Text(
                            'Ketuk kotak untuk pilih Gambar',
                            style: TextStyle(color: Colors.pink),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Text(
                          imageCtrl.message == 'success'
                              ? '${imageCtrl.message}: Berhasil Unggah Gambar!'
                              : '',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 17)),
                      Text(
                          imageCtrl.message == 'failed'
                              ? '${imageCtrl.message}'
                              : '',
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // foreground
                      backgroundColor: const Color(0xFF9C27B0), // background
                    ),
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Get.find<ImageController>().upload(id, urlServer, token);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            Future.delayed(const Duration(milliseconds: 1200),
                                () {
                              Navigator.of(context).pop(true);
                            });
                            return const AlertDialog(
                              title: Text('Proses Unggah Gambar..'),
                              content: Text(
                                  'Mohon menunggu! Unggah Gambar sedang diproses...'),
                            );
                          });
                    },
                  ),
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }
}
