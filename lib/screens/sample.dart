import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs = images;
      });
    }
  }

  File? _model;
  File? _cloth;

  Future getModel() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _model = File(pickedFile!.path);
    });
  }

  Future getCloth() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _model = File(pickedFile!.path);
    });
  }

  Future<http.Response> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      )
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Upload");

    } else {
      print("Image Upload failed");
    }
    return await http.Response.fromStream(response);
  }

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Photo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_model == null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: _imageSize,
                  minWidth: _imageSize,
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: _imageSize,
                  ),
                ),
              )
            else
              Container(
                width: _imageSize,
                height: _imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.primary),
                  image: DecorationImage(
                    image: FileImage(File(_model!.path)),
                    fit: BoxFit.cover),
                  ),
                ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: getModel,
              child: Text("Selected Fitting shot"),
            ),
            if (_cloth == null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: _imageSize,
                  minWidth: _imageSize,
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: _imageSize,
                  ),
                ),
              )
            else
              Container(
                width: _imageSize,
                height: _imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.primary),
                  image: DecorationImage(
                      image: FileImage(File(_cloth!.path)),
                      fit: BoxFit.cover),
                ),
              ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: getCloth,
              child: Text("Selected Cloth"),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => {
                uploadImage(_cloth!),
              },
              child: Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
