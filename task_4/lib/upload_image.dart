import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  File? image ;
  final _picker = ImagePicker();

  Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);

    if(pickedFile!= null ){
      image = File(pickedFile.path);
      setState(() {

      });
    }else {
      throw Exception('no image selected');
    }
  }

  Future<void> uploadImage ()async{

    setState(() {
    });

    var stream  =http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = "Static title" ;

    var multiport = http.MultipartFile(
        'image',
        stream,
        length);

    request.files.add(multiport);

    var response = await request.send() ;

    throw Exception(response.stream.toString());
    if(response.statusCode == 200){
      setState(() {
      });
      throw Exception('image uploaded');
    }else {
      throw Exception('failed');
      setState(() {
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? Center(child: Text('Pick Image'),)
                    :
               Center(
                 child: Image.file(
                   File(image!.path).absolute,
                   height: 100,
                   width: 100,
                   fit: BoxFit.cover,
                 ),
               ),
              ),
            ),
            SizedBox(height: 150,),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: Center(child: Text('Upload')),
              ),
            )
          ],
        ),
    );
  }
}