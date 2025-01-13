import 'package:flutter/material.dart';
import 'package:to_do_app/auth/auth_service.dart';
import 'package:to_do_app/components/my_drawer.dart';
import 'package:to_do_app/components/my_todos.dart';
import 'package:to_do_app/constants/color.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  void logout(){
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      drawer: const MyDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            searchBox(),
            Expanded(
              child: ListView(
                children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: const Text('Your ToDos', 
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const MyTodos(),
                const MyTodos()
               ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: tdBGColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/avatar.jpeg'),
              ),
            ),
          ],
        ));
  }
}
