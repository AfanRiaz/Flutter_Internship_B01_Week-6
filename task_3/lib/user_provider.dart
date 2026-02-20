import 'package:flutter/material.dart';
import 'package:users_app/api_call.dart';
import 'package:users_app/model/user_api.dart';

class UserProvider with ChangeNotifier{
  ApiCall _apiCall=ApiCall();
  bool isLoading=false;
  List<UserApi> _api= [];
  List<UserApi> get api{
    return _api;
  }
  Future<void> getAllUsers() async{
    isLoading=true;
    notifyListeners();
    final response=await _apiCall.getApi();
    _api=response;
    isLoading=false;
    notifyListeners();
  }
}