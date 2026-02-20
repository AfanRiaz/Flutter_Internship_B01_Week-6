import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/posts_model.dart';
void main(){
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostsModel> postList=[];
  Future<List<PostsModel>> getPostApi ()async{
    final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'),headers: {
      "Accept": "application/json",
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    },);
    var data=jsonDecode(response.body.toString());
    if(response.statusCode==200){
      postList.clear();
      for(Map i in data){
        postList.add(PostsModel.fromJson(i));
      }
      return postList;
    }
    else{
      throw Exception("Error Occurred, Status code: ${response.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Basics App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPostApi(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.hasError) {
                    return Center(child: Text("Data loading error"));
                  }
                  else
                  {
                    return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${postList[index].id}\nTitle:", style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                  Text(postList[index].body.toString()),
                                  Text("Body:", style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                  Text(postList[index].title.toString()),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}

