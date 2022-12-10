import 'package:flutter/material.dart';
import 'package:mydiary/data/diary.dart';
import 'package:mydiary/data/util.dart';
import 'package:mydiary/write.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Container(
        child: getPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => DiaryWritePage(
              diary: Diary(
                  date: Utils.getFormatTime(DateTime.now()),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/a1.jpg"),
            ),
          ));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "오늘",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: "기록",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: "통계",
          ),
        ],
        onTap: (idx) {
          setState(() {
            selectIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (selectIndex == 0) {
      return getTodayPage();
    } else if (selectIndex == 1) {
      return getHistoryPage();
    } else {
      return getChartPage();
    }
  }

  // 오늘 Page
  Widget getTodayPage() {
    return Container();
  }

  // 기록 Page
  Widget getHistoryPage() {
    return Container();
  }

  // 통계 Page
  Widget getChartPage() {
    return Container();
  }
}
