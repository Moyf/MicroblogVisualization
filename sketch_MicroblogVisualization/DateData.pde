// 日期数据类，年月日


class DateData {
  int year, month, day;
  TimeData time;
  
  DateData(int y, int m, int d) {
    
    year  = y;
    month = m;
    day   = d;

  }
  
  
  int getYear() {
    return year;
  }
  
  
  int getMonth() {
    return month;
  }
  
  int getDay() {
    return day;
  }
  
}
