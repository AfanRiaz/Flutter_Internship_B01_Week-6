import 'dart:convert';

import 'package:users_app/model/user_api.dart';
import 'package:http/http.dart' as http;
class ApiCall {
  List<UserApi> userlist=[];
  Future<List<UserApi>> getApi() async{
    final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'),headers: {
      "Accept": "application/json",
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    },);
    var data=jsonDecode(response.body);
    if(response.statusCode==200){
      for(Map i in data){
        userlist.add(UserApi.fromJson(i));
      }
      return userlist;
    }
    else {
      throw Exception("error occurred");
    }
  }
}