import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydiary/data/dbconfig.dart';
import 'package:mydiary/data/diary.dart';

class DiaryWritePage extends StatefulWidget {
  final Diary diary;

  DiaryWritePage({this.diary, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DiaryWritePageState();
  }
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  List<String> images = [
    "assets/img/a1.jpg",
    "assets/img/a2.jpg",
    "assets/img/a3.jpg",
    "assets/img/a4.jpg",
  ];

  List<String> statusImg = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png",
  ];

  int imgIndex = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.diary.title;
    memoController.text = widget.diary.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              widget.diary.title = nameController.text;
              widget.diary.memo = memoController.text;
              // Mount Property
              await dbHelper.insertDiary(widget.diary);
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text(
              "저장",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return InkWell(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                width: 100,
                height: 100,
                child: Image.asset(
                  widget.diary.image,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.diary.image = images[imgIndex];
                  imgIndex++;
                  imgIndex = imgIndex % images.length;
                });
              },
            );
          } else if (idx == 1) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  statusImg.length,
                  (idx_) {
                    return InkWell(
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: idx_ == widget.diary.status
                                ? Colors.lightBlue
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(7),
                        child: Image.asset(
                          statusImg[idx_],
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        setState(
                          () {
                            widget.diary.status = idx_;
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
          } else if (idx == 2) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Text(
                "제목",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          } else if (idx == 3) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
              ),
            );
          } else if (idx == 4) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Text(
                "내용",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          } else if (idx == 5) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: TextField(
                controller: memoController,
                minLines: 10,
                maxLines: 20,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            );
          }

          return Container();
        },
        itemCount: 6,
      ),
    );
  }
}
