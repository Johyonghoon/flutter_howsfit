import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploader extends StatefulWidget {
  const ImageUploader({Key? key}) : super(key: key);

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  List<File> _images = [];
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
      _cloth = File(pickedFile!.path);
    });
  }

  Future<http.Response> uploadImage(File modelFile, File clothFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'model',
        modelFile.path,
      )
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'cloth',
        clothFile.path,
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
    final _imageSize = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Images"),
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
                uploadImage(_model!, _cloth!),
              },
              child: Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
