import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> _images = [];

  Future getImages() async {
    List<XFile>? pickedFiles =
    await ImagePicker().pickMultiImage(imageQuality: 80);

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<http.Response> uploadImages(List<File> images) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/upload'),
    );

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Images Upload");

    } else {
      print("Images Upload failed");
    }
    return await http.Response.fromStream(response);
  }

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Photos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_images.isEmpty)
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
              Column(
                children: _images.map((image) {
                  return Container(
                    width: _imageSize,
                    height: _imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: getImages,
              child: Text("Select Images"),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: _images.isNotEmpty ? () => uploadImages(_images) : null,
              child: Text("Upload Images"),
            ),
          ],
        ),
      ),
    );
  }
}
