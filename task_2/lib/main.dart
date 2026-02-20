import 'dart:convert';

import 'package:crud_api_app/Model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
class PostApi {

  Future<List<PostModel>> getApi() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {
        "Accept": "application/json",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
      },
    );
    List data = jsonDecode(response.body);
    List<PostModel> postList = [];
    for (var i in data) {
      postList.add(PostModel.fromJson(i));
    }
    return postList;
  }

  Future<void> createPost() async {
    await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      body: jsonEncode({
        'title': 'My Post',
        'body': 'Hello I am creating post',
      }),
    );
  }

  Future<void> updatePost() async {
    await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      body: {
        'title': 'Updated Post',
        'body': 'Post updated by me',
      },
    );
  }

  Future<void> deletePost() async {
    await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  }
}
class _HomePageState extends State<HomePage> {
  PostApi api = PostApi();
  late Future<List<PostModel>> post;

  @override
  void initState() {
    super.initState();
    post = api.getApi();
  }

  void refresh() {
    setState(() {
      post = api.getApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("API Operations")),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await api.createPost();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post Created")),
          );
          refresh();
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<PostModel>>(
        future: post,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                PostModel post = snapshot.data![index];

                return ListTile(
                  title: Text(post.title.toString()),
                  subtitle: Text(post.body.toString()),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await api.updatePost();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Post Updated")),
                          );
                          refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await api.deletePost();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Post Deleted")),
                          );
                          refresh();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("Error loading data:"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}