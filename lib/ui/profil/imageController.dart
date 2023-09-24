import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ImageController extends GetxController {
  bool? _loading;
  bool? get loading => _loading;
  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;
  String? _message;
  String? get message => _message;
  final _picker = ImagePicker();

  Future<void> setNull(String msg) async {
    _message = '';
    _pickedFile = null;
    update();
  }

  Future<void> pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      XFile? img = XFile(image.path);
      img = await _cropImage(imageFile: img);
      _pickedFile = img;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<XFile?> _cropImage({required XFile imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    print('berhasil');
    return XFile(croppedImage.path);
  }

  Future<bool> upload(String id, String urlServer, String token) async {
    // update();
    bool success = false;
    _loading = true;
    http.StreamedResponse response =
        await updateProfile(_pickedFile, id, urlServer, token);

    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String msg = map['message'];
      success = true;
      _message = msg;

      Future.delayed(const Duration(milliseconds: 2000), () {
        _pickedFile = null;
        _message = null;
        update();
      });
      update();
      print(msg);
      print('Success uploading image');
    } else {
      Map map = jsonDecode(await response.stream.bytesToString());
      String msg = map['message'];

      _pickedFile = null;
      print(msg);
      print('error uploading image');
      update();
    }

    return success;
  }

  Future<http.StreamedResponse> updateProfile(
      XFile? data, String id, String urlServer, String token) async {
    String urlApi = 'http://$urlServer/api/akun/$id/photo';
    print(urlApi);
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(urlApi));
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $token',
    });
    if (GetPlatform.isMobile && data != null) {
      File _file = File(data.path);
      request.files.add(http.MultipartFile(
          'image', _file.readAsBytes().asStream(), _file.lengthSync(),
          filename: _file.path.split('/').last));
    }

    http.StreamedResponse response = await request.send();
    return response;
  }
}
