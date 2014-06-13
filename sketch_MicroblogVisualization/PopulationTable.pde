// 人口数据

class PopulationTable{
  int rowCount;			//行数
  int columnCount;		//列数
  int[][] data;		//数据内容
  String[] rowNames;	//行名
  String[] columnNames;	//列名

  String[] zoneNames;   // 每行的第一列数据
  
  
  //构建器，传入参数为文件名
  PopulationTable(String filename) {

    String[] rows = loadStrings(filename);
    String[] columns = split(rows[0], ",");
    columnNames = subset(columns, 1); // upper-left corner ignored
    
    // 计数
    columnCount = columnNames.length;

    // 行名与数据
    rowNames = new String[rows.length-1];
    zoneNames  = new String[rows.length-1];
    
    data = new int[rows.length-1][];

    // 从第1行开始读取（0行只是列名）
    for (int i = 1; i < rows.length; i++) {
      
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }

      // split the row on the tabs
      // String[] pieces = split(rows[i], TAB);
      String[] pieces = split(rows[i], ",");
      String[] zonePieces = split(rows[i], ",");
      
           
      // copy row title
      rowNames[rowCount] = pieces[0];
      zoneNames[rowCount] = zonePieces[0];
      // popDensity[rowCount] = zonePieces[1];
      // dayPopulation[rowCount] = zonePieces[2];
      
      
      // copy data into the table starting at pieces[1]
      data[rowCount] = parseInt(subset(pieces, 1));
      
      // zoneNames[rowCount] = parseFloat(subset(zonePieces, 1));

      // increment the number of valid rows found so far
      rowCount++;      
    }
    // resize the 'data' array as necessary
    data = (int[][]) subset(data, 0, rowCount);
  }

  
  // 返回行计数
  int getRowCount() {
    return rowCount;
  }
  
  // 返回指定行名
  String getRowName(int rowIndex) {
    return rowNames[rowIndex];
  }
  
  // 返回所有行名
  String[] getRowNames() {
    return rowNames;
  }

  

  // 根据行名查找,如果没有则返回 -1
  // 这将返回第一个匹配名字的行的序号
  // 		(如果想要更简便,将行名放入一个Hash表,直接映射一个行号)
  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (rowNames[i].equals(name)) {
        return i;
      }
    }
    //println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  // 返回列计数
  int getColumnCount() {
    return columnCount;
  }
  
  
  // 获取指定列名
  String getColumnName(int colIndex) {
    return columnNames[colIndex];
  }
  
  // 获取所有列名
  String[] getColumnNames() {
    return columnNames;
  }


  // 自定义函数 getFloat
  // 返回指定行列的数据,同时排除例外情况
  // 在这里重定义,以提供更好的错误提示信息
  float getFloat(int rowIndex, int col) {
    // Remove the 'training wheels' section for greater efficiency
    // It's included here to provide more useful error messages
    
    // begin training wheels
    if ((rowIndex < 0) || (rowIndex >= data.length)) {
      throw new RuntimeException("There is no row " + rowIndex);
    }
    if ((col < 0) || (col >= data[rowIndex].length)) {
      throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
    }
    // end training wheels
    
    return data[rowIndex][col];
  }
  
  
  // 判断是否有效
  boolean isValid(int row, int col) {
    if (row < 0) return false;
    if (row >= rowCount) return false;
    //if (col >= columnCount) return false;
    if (col >= data[row].length) return false;
    if (col < 0) return false;

    return !Float.isNaN(data[row][col]);
  }

  // 获取最大列数
  float getColumnMin(int col) {
    float m = Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      if (isValid(row, col)) {
        if (data[row][col] < m) {
          m = data[row][col];
        }
      }
    }
    return m;
  }


  float getColumnMax(int col) {
    float m = -Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      if (isValid(row, col)) {
        if (data[row][col] > m) {
          m = data[row][col];
        }
      }
    }
    return m;
  }

  
  float getRowMin(int row) {
    float m = Float.MAX_VALUE;
    for (int col = 0; col < columnCount; col++) {
      if (isValid(row, col)) {
        if (data[row][col] < m) {
          m = data[row][col];
        }
      }
    }
    return m;
  } 


  float getRowMax(int row) {
    float m = -Float.MAX_VALUE;
    for (int col = 0; col < columnCount; col++) {
      if (isValid(row, col)) {
        if (data[row][col] > m) {
          m = data[row][col];
        }
      }
    }
    return m;
  }


  float getTableMin() {
    float m = Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < columnCount; col++) {
        if (isValid(row, col)) {
          if (data[row][col] < m) {
            m = data[row][col];
          }
        }
      }
    }
    return m;
  }


  float getTableMax() {
    float m = -Float.MAX_VALUE;
    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < columnCount; col++) {
        if (isValid(row, col)) {
          if (data[row][col] > m) {
            m = data[row][col];
          }
        }
      }
    }
    return m;
  }

 void showData(){
   
   println("rowCount: " + rowCount);
   println("columnCount: " + columnCount + "\n");
   
   for (int i = 0; i < columnCount; i++){
     println("columnNames[" + i + "] = " + columnNames[i]);
   
   }
   
    for (int i = 0; i < rowCount; i++){
      println("rowNames[" + i + "] = " + rowNames[i]);
      println("Zone: " + zoneNames[i]);// + ",  Population_Density: " + popDensity[i] + ",  Day_Population: " + dayPopulation[i]);

      println("data[i]: "+ data[i][0] + ", "+ data[i][1]);
   
   }
   
 }
 
  int getMaxPopulation(){
      int maxPop = 0;
      int temp = 0;
   
    for (int i = 0; i < rowCount; i++){
       
      if (temp < data[i][0]){
        temp = data[i][0];
      }
      
      maxPop = temp;
    }
   
   println("the Max population is: " + maxPop);
   return maxPop;
  
 }
 
}
