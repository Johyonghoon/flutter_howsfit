import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GetVitonImage extends StatefulWidget {

  const GetVitonImage({Key? key}) : super(key: key);

  @override
  State<GetVitonImage> createState() => _GetVitonImageState();
}

class _GetVitonImageState extends State<GetVitonImage> {

  

  void onButtonPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("가상 시착"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text("처음으로 돌아가기"),
            ),
          ],
        ),
      ),
    );
  }
}
