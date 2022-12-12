import 'package:flutter/material.dart';
import 'package:mydiary/data/dbconfig.dart';
import 'package:mydiary/data/diary.dart';
import 'package:mydiary/data/util.dart';
import 'package:mydiary/write.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final dbHelper = DatabaseHelper.instance;
  Diary todayDiary;
  Diary historyDiary;
  List<Diary> allDiaries = [];
  List<String> statusImg = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  DateTime time = DateTime.now();

  CalendarController calendarController = CalendarController();

  void getTodayDiary() async {
    List<Diary> diary =
        await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));

    if (diary.isNotEmpty) {
      todayDiary = diary.first;
    }

    setState(() {});
  }

  void getAllDiary() async {
    allDiaries = await dbHelper.getAllDiary();

    setState(() {});
  }

  @override
  void initState() {
    // setState() 호출 불가
    super.initState();
    getTodayDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text(""),
      ),
      */

      body: Container(
        child: getPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectIndex == 0) {
            Diary d_;
            if (todayDiary != null) {
              d_ = todayDiary;
            } else {
              d_ = Diary(
                  date: Utils.getFormatTime(DateTime.now()),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/a1.jpg");
            }
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => DiaryWritePage(diary: d_),
            ));
            // On Test
            getTodayDiary();
          } else {
            Diary d_;
            if (historyDiary != null) {
              d_ = historyDiary;
            } else {
              d_ = Diary(
                  date: Utils.getFormatTime(time),
                  title: "",
                  memo: "",
                  status: 0,
                  image: "assets/img/a1.jpg");
            }
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => DiaryWritePage(diary: d_),
            ));
            // On Test
            getDiaryByDate(time);
          }
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
          if (selectIndex == 2) {
            getAllDiary();
          }
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
    if (todayDiary == null) {
      return Container(
        child: const Text(
          "오늘의 다이어리를 작성하지 않았습니다.",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              todayDiary.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ListView(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${DateTime.now().month}.${DateTime.now().day}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Image.asset(
                        statusImg[todayDiary.status],
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todayDiary.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        height: 12,
                      ),
                      Text(todayDiary.memo,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getDiaryByDate(DateTime date) async {
    List<Diary> d = await dbHelper.getDiaryByDate(Utils.getFormatTime(date));

    setState(() {
      if (d.isEmpty) {
        historyDiary = null;
      } else {
        historyDiary = d.first;
      }
    });
  }

  // 기록 Page
  Widget getHistoryPage() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: TableCalendar(
                calendarController: calendarController,
                onDaySelected: (date, events, holidays) {
                  print(date); // Debug Code
                  time = date;
                  getDiaryByDate(date);
                },
              ),
            );
          } else if (idx == 1) {
            if (historyDiary == null) {
              return Container();
            }
            return Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${time.month}.${time.day}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Image.asset(
                        statusImg[historyDiary.status],
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(historyDiary.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        height: 12,
                      ),
                      Text(historyDiary.memo,
                          style: const TextStyle(fontSize: 16)),
                      Image.asset(
                        historyDiary.image,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
        itemCount: 2,
      ),
    );
  }

  // 통계 Page
  Widget getChartPage() {
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(statusImg.length, (idx_) {
                  return Container(
                    child: Column(
                      children: [
                        Image.asset(
                          statusImg[idx_],
                          fit: BoxFit.contain,
                        ),
                        Text(
                            "${allDiaries.where((element) => element.status == idx_).length}개"),
                      ],
                    ),
                  );
                }),
              ),
            );
          } else if (idx == 1) {
            return Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: List.generate(allDiaries.length, (idx_){
                  return Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(allDiaries[idx_].image, fit: BoxFit.cover,),
                  );
                },
                ),
              ),
            );
          }

          return Container();
        },
        // 임의의 값
        itemCount: 5,
      ),
    );
  }
}
