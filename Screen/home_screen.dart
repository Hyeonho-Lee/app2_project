import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Menus { progress, news, ends}

extension ParseToString on Menus {
  String toStrings() {
    var result;

    if (this.toString().split('.').last == 'progress') {
      result = '진행';
    }else if (this.toString().split('.').last == 'news') {
      result = '예정';
    }
    if (this.toString().split('.').last == 'ends') {
      result = '완료';
    }

    return result;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<bool> _selections1 = List.generate(3, (index) => false);
  Menus? _selection;
  String? lavels;

  var response;
  List? all_event;

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
    lavels = "진행중";

    getJSONDate("progress");
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

    final festival_bg = Image.asset(
      'image/festival.png',
      width: 120,
      height: 180,
      fit: BoxFit.fitHeight,
    );

    final slides = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 10),
        Text(
          '축제 일정',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 200),
        Row(
          children: <Widget>[
            Text(
              '${lavels}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            PopupMenuButton(
              icon: Icon(Icons.settings),
              onSelected: (Menus result) {
                setState(() {
                  _selection = result;
                  if (_selection == Menus.news) {
                    getJSONDate("new");
                    lavels = "예정중";
                  }

                  if (_selection == Menus.progress) {
                    getJSONDate("progress");
                    lavels = "진행중";
                  }

                  if (_selection == Menus.ends) {
                    getJSONDate("end");
                    lavels = "완료중";
                  }
                });
              },
              itemBuilder: (BuildContext context) => Menus.values
                    .map((value) => PopupMenuItem (
                      value: value,
                      child: Text(value.toStrings()),
                )).toList(),
            )
          ],
        )
      ],
    );

    final cards = ListView.builder(
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
                height: 200,
                onPressed: () {
                  print('눌럿냐');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: festival_bg,
                    ),
                    SizedBox(width: 20),
                    Container (
                      child: Column(
                        children: <Widget>[
                          Container(
                            //color: Colors.red,
                              height: 50,
                              width: 190,
                              child: Text(
                                all_event![0]['행사명'][index.toString()],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  letterSpacing: 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                                //overflow: TextOverflow.ellipsis,
                              )
                          ),
                          SizedBox(height: 1),
                          Container(
                            //color: Colors.red,
                              height: 20,
                              width: 190,
                              child: Text(
                                '기간: ' + all_event![0]['시작일자'][index.toString()] + ' ~ ' + all_event![0]['종료일자'][index.toString()],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.justify,
                                //overflow: TextOverflow.ellipsis,
                              )
                          ),
                          SizedBox(height: 1),
                          Container(
                            //color: Colors.red,
                              height: 20,
                              width: 190,
                              child: Text(
                                '장소: ' + all_event![0]['개최장소'][index.toString()],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.justify,
                                //overflow: TextOverflow.ellipsis,
                              )
                          ),
                          SizedBox(height: 1),
                          Container(
                            //color: Colors.red,
                              height: 50,
                              width: 190,
                              child: Text(
                                '내용: ' + all_event![0]['행사내용'][index.toString()],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  letterSpacing: 0.1,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.justify,
                                //overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: all_event![0]["행사명"].length,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text('로고'),
        centerTitle: true,
        backgroundColor: Colors.white24,
        actions: [
          IconButton(
              onPressed: () {
                print('아이콘 클릭');
              },
              icon: Icon(Icons.menu)
          ),
        ],
      ),
      //backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              child: Column(
                children: [
                  Container(
                    //color: Colors.blue,
                    height: MediaQuery.of(context).size.height/20,
                    child: slides,
                  ),
                  SizedBox(height: 2),
                  Container(
                    //color: Colors.black,
                    height: MediaQuery.of(context).size.height/1.2,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: cards,
                    ),
                  )
                ],
              ),
            )
          )
        ),
      )
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
