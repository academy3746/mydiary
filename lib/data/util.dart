// 날짜 기능 수행 페이지

class Utils
{
  static int getFormatTime(DateTime date) {
    return int.parse("${date.year}${makeTwoDigit(date.month)}${makeTwoDigit(date.day)}");
  }

  static numToDateTime(int date) {
    String d = date.toString();

    // ex. 2022/12/03

    int year = int.parse(d.substring(0, 4));
    int month = int.parse(d.substring(4, 6));
    int day = int.parse(d.substring(6, 8));

    return DateTime(year, month, day);
  }

  static String makeTwoDigit(int num) {
    return num.toString().padLeft(2, "0");
    // 10 이하 한 자리 날짜 왼쪽에 0을 붙여서 출력할 것!
  }
}