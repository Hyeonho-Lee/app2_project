import 'home_screen.dart';
import '/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {

  final int indexss;
  final int type_indexss;

  const DetailScreen({Key? key, required this.indexss, required this.type_indexss}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  var response;
  List? all_event;

  late int indexs = widget.indexss;
  late int type_indexs = widget.type_indexss;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });

    if (type_indexs == 1) {
      getJSONDate("new");
    }

    if (type_indexs == 2) {
      getJSONDate("progress");
    }

    if (type_indexs == 3) {
      getJSONDate("end");
    }

    //print(indexs);
    //print(type_indexs);
  }

  @override
  Widget build(BuildContext context) {

    final serverText = Text(
      '서버와 연결되지 않습니다.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.center,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text('축제 안내'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Center(
              child: Container(
                width: 500,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${loggedInUser.nickname} 님\n어서오세요!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                      //overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                  width: 500,
                  height: 400,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            //print("공지사항 클릭");
                            Navigator.of(context).pushReplacementNamed('/notice');
                          },
                          child: Text(
                            '공지사항 ▣',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            //print("프로필 클릭");
                            Navigator.of(context).pushReplacementNamed('/profile');
                          },
                          child: Text(
                            '프로필 ▣',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            //print("알림 클릭");
                            Navigator.of(context).pushReplacementNamed('/alert');
                          },
                          child: Text(
                            '알림 ▣',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  width: 320,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    'image/festival.png',
                    width: 140,
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 320,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: all_event!.length == 0 ?
                  serverText :
                  Column(
                    children: <Widget>[
                      Text(
                        all_event![0]['행사명'][indexs.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 1),
                      Text(
                        '기간: ' + all_event![0]['시작일자'][indexs.toString()] + ' ~ ' + all_event![0]['종료일자'][indexs.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 1),
                      Text(
                        '장소: ' + all_event![0]['개최장소'][indexs.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 1),
                      Text(
                        '내용: ' + all_event![0]['행사내용'][indexs.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 1),
                      Text(
                        '홈페이지주소: ' + all_event![0]['홈페이지주소'][indexs.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Future getJSONDate(String value) async{
    var url;

    if (value == "new") {
      url = 'http://3.15.67.95:5050/new_event_busan';
    }else if (value == "end") {
      url = 'http://3.15.67.95:5050/end_event_busan';
    }else if (value == "progress") {
      url = 'http://3.15.67.95:5050/progress_busan';
    }else {
      print("주소를 받아오지 못하였습니다.");
    }

    print(url);
    response = await http.get(Uri.parse(url));

    setState(() {
      if (response.statusCode == 200) {
        String text_replace = response.body;
        text_replace = text_replace.replaceAll('&#39;', '"');

        var json_decode = jsonDecode(text_replace);
        all_event = new List.empty(growable: true);
        all_event!.add(json_decode);

        //print(all_event);
        //print(all_event![0]["행사명"]['0']);
      }
    });
  }
}
