import 'home_screen.dart';
import '/model/user_model.dart';
import '/model/notice_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {

  NoticeModel notices = NoticeModel();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var all_text = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    all_text.clear();

    FirebaseFirestore.instance
        .collection("notice")
        .get()
        .then((value) {
          for (int i = 0; i < value.docs.length; i++) {
            all_text.add(value.docs[i].data()["text"]);
          }
            all_text = List.from(all_text.reversed);
        }
      );

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
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
      appBar: AppBar(
        title: Text('공지사항'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
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
          child: Column(
            children: <Widget>[
              Container(
                width: 350,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: all_text.length != 0 ?
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        child: Material(
                          color: Colors.black12,
                          child: MaterialButton(
                            elevation: 5,
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            minWidth: 500,
                            height: 100,
                            onPressed: () {
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '${index + 1}. ${all_text[index].toString()}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 0.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: all_text.length,
                ):
                    serverText
              ),
            ],
          )
        ),
      ),
    );
  }
}
