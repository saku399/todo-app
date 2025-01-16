import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:to_do_app/auth/auth_service.dart';
import 'package:to_do_app/components/my_drawer.dart';
import 'package:to_do_app/components/my_todos.dart';
import 'package:to_do_app/constants/color.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logout(){
    final _auth = AuthService();
    _auth.signOut();
  }
  final TextEditingController _textController = TextEditingController();

  String? toDos;

  List<String> myTodos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Container(
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
       Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [BoxShadow(
                  color: Colors.grey, 
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Add a new ToDo',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20, 
              right: 20
            ),
            child: ElevatedButton(
              onPressed: () {
               if (_textController.text.isNotEmpty) {
                _addNewTodo();
                _toDos();
                //_fetchTodos();
               } else {
                print('text is empty');
               }
              }, 
              child: const Text('+', style: TextStyle(fontSize: 40,),),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(60, 60),
                elevation: 10,
              )
              ),
          )
        ],),
       )
      ],
     )
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
                child: const Icon(Icons.person),
              ),
            ),
          ],
        ));
  }
  Future<void> _addNewTodo() async {
    print('add new todo');
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid == null || uid.isEmpty) return;

    final newTodo = _textController.text.trim();
    if (newTodo.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'toDos': FieldValue.arrayUnion([newTodo]),
      });

      setState(() {
        myTodos.add(newTodo);
        _textController.clear();
      });
    } catch (e) {
      debugPrint('Failed to add new todo: $e');
    }
  }

  Future<void> _fetchTodos() async {
    print('fetch todo');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (!userDoc.exists) return; // ドキュメントが存在しない場合は何もしない

    final data = userDoc.data() as Map<String, dynamic>?;
    // toDosフィールドが未登録でnullの場合は空リストとする
    final List<dynamic> fetchedList = data?['toDos'] ?? [];
    // dynamic配列をList<String>に変換
    final List<String> todosAsStrings = fetchedList.map((e) => e.toString()).toList();

    setState(() {
      myTodos = todosAsStrings;
    });
  }
  Future<void> _toDos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      setState(() {
        var data = userDoc.data() as Map<String, dynamic>?;
        toDos = data != null && data.containsKey('toDos')
            ? data['toDos']
            : 'ToDo';
      });
    }
  }
}
