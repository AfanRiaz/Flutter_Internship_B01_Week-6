import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/user_provider.dart';

void main(){
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>UserProvider(),
        child: MaterialApp(
        home: HomePage(),
    debugShowCheckedModeBanner: false,
    ),);
  }
  }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      Provider.of<UserProvider>(context,listen: false).getAllUsers();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User App"),
      ),
      body: Consumer<UserProvider>(builder: (context,value,child){
        final users=value.api;
        if(value.isLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else
        {
          return ListView.builder(
            itemCount: value.api.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.id!.toString()),),
                title: Text(user.username!,style: TextStyle(fontSize: 24),),
                subtitle: Text(user.email!),
                trailing: Text("Company: ${user.company!.name.toString()}"),
              );
            },
          );
        }
      }),
    );
  }
}
