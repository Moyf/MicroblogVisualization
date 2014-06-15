//====================================================================
// Data Visualization: Draw Charts of population of various zones.
//
// Auther: Moy
// Date  : 2014/6/15
//
//====================================================================


PopulationTable dPopulation;
int dPopRowCount, dPopColumnCount;
float maxPop;
float sumPop;
float sumDayPop;


// the Pie Chart
int coreX, coreY, coreR, coreRR;
int coreX2, coreY2, coreR2;
int[][] tempData;
int[][] tempData2;

// the Column Chart
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
color baseColor = color(102, 175, 106);
color upperColor = color(246, 145, 29);
int popInterval = 50000;
int popIntervalMinor = 10000;
float pDataMin, pDataMax, pDayDataMax;

PFont plotFont; 

color fontColor;
color pieColor[];

PVector mousePos;

class Visualization_Population {
  
  Visualization_Population() {
    
    dPopulation = new PopulationTable("Population.csv");
    dPopRowCount = dPopulation.rowCount;
    dPopColumnCount = dPopulation.columnCount;

    
    // Column Chart
    plotX1 = 80; 
    plotX2 = width - plotX1;
    labelX = plotX2 - 150;
    plotY1 = 60;
    plotY2 = height - plotY1-30;
    labelY = height - 25;

    maxPop = dPopulation.getMaxPopulation();
    sumPop = dPopulation.getSumPopulation();
    sumDayPop = dPopulation.getSumDaytimePopulation();

    // Pie Chart
    coreX = width/2;
    coreY = height/2+45;
    coreR = 200;
    coreRR = 200;
    coreX2 = height - coreX;
    coreY2 = height/2+45;
    coreR2 = 200;
    tempData = sort_reverse(dPopulation.data);
    tempData2 = sort_reverse2(dPopulation.data);
    
    pDataMin = 0;
    pDataMax = dPopulation.getMaxPopulation(); 
    pDayDataMax = dPopulation.getMaxDaytimePopulation(); 

    plotFont = createFont("SansSerif", 20);
    textFont(plotFont);
    color fontColor = color(40);
    
    pFlag = 0;
  }
  

//====================================================================
// 绘制区域
//====================================================================

  void draw(){
    if(pFlag == 0) {
      drawChart1();
    }
    else 
    if (pFlag == 1){
      drawChart2();
    }
    sBtns.draw();
  }

  // 图表一: 饼图
  void drawChart1() {
    drawTitle("Chart 1: Pie Graph of Population");
    drawPopulationCookie();
    // drawPopulationCookie2();
    
  }

  // 图表二: 柱状图
  void drawChart2() {
    fill(200, 200, 200, 210);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    drawAxisLabels();
    drawTitle("Chart 2: Bar Graph of Population");

    drawZoneLabels();
    drawPopulationLabels();
    drawDataArea();
    
  }

  
  void drawTitle(String title) {
    fill(0);
    textSize(20);
    textAlign(CENTER);
    // String title = dPopulation.getColumnName(0);
    text(title, (plotX1 + plotX2)/2, plotY1 - 10);
  }


//====================================================================
// 饼图
//====================================================================

  void drawPopulationCookie(){
    
    textAlign(CENTER);
    textSize(15);
    fill(fontColor);
    text("Population Density", coreX, coreY-coreR-35);

    float tempEnd = -HALF_PI;
    float[] endAngle = new float[dPopRowCount+1];
    float[] percent = new float[dPopRowCount];
    endAngle[0] = -HALF_PI;

    color[] pieColor = new color[dPopRowCount];
    for (int i = 0; i < dPopRowCount; i++) {
      // pieColor[i] = color(i*(256/dPopRowCount), 70-(i%5)*3, 90);
      pieColor[i] = color(200 + (i%4)*10, 150-(i%5)*3, 120);
    
    }


    for (int row = 0; row < dPopRowCount; row++) {
      percent[row] = tempData[row][0]/sumPop;
      endAngle[row+1] = endAngle[row] + percent[row]*TWO_PI;
      println("angle["+row+"] = " + endAngle[row]/PI);

      ellipseMode(RADIUS);
      fill(pieColor[row]);
      // ellipse(coreX, coreY, coreR, coreR);
      // arc(coreX, coreY, coreR, coreR, tempEnd, tempEnd + percent * TWO_PI - PI/500, PIE);
      arc(coreX, coreY, coreR, coreRR, endAngle[row], endAngle[row+1], PIE);
      
      // tempEnd += percent * TWO_PI;
    
    }
    
    
    for (int i = 0; i < dPopRowCount; i++) {
      if (mouseIsInArc(i, endAngle)) {
        
        fill(pieColor[i]);
        arc(coreX, coreY, coreR+30, coreRR+30, endAngle[i], endAngle[i+1], PIE);
        
        fill(222, 50, 80);
        textSize(13);
        textAlign(LEFT, BOTTOM);
        text("Zone Name: "+dPopulation.zoneNames[i]+"\n Density" + (int)dPopulation.getFloat(i, 0), mouseX, mouseY);
      }
    }
  }


  // 白天的数据
  void drawPopulationCookie2(){
    
    float tempEnd = -HALF_PI;
    float[] endAngle = new float[dPopRowCount+1];
    float[] percent = new float[dPopRowCount];
    endAngle[0] = -HALF_PI;

    color[] pieColor = new color[dPopRowCount];
    for (int i = 0; i < dPopRowCount; i++) {
      // pieColor[i] = color(i*(256/dPopRowCount), 70-(i%5)*3, 90);
      pieColor[i] = color(120, 150-(i%5)*3, 200 + (i%4)*10);
    
    }


    for (int row = 0; row < dPopRowCount; row++) {
      percent[row] = tempData2[row][1]/sumDayPop;
      endAngle[row+1] = endAngle[row] + percent[row]*TWO_PI;
      println("angle["+row+"] = " + endAngle[row]/PI);

      ellipseMode(RADIUS);
      fill(pieColor[row]);
      // ellipse(coreX, coreY, coreR, coreR);
      // arc(coreX, coreY, coreR, coreR, tempEnd, tempEnd + percent * TWO_PI - PI/500, PIE);
      arc(coreX2, coreY2, coreR2, coreR2, endAngle[row], endAngle[row+1], PIE);
      
      // tempEnd += percent * TWO_PI;
    
    }
    
    
    for (int i = 0; i < dPopRowCount; i++) {
      if (mouseIsInArc(i, endAngle)) {
        
        fill(pieColor[i]);
        arc(coreX2, coreY2, coreR2+30, coreR2+30, endAngle[i], endAngle[i+1], PIE);
        
        fill(222, 50, 80);
        textSize(13);
        textAlign(LEFT, BOTTOM);
        text("Zone Name: "+dPopulation.zoneNames[i]+"\n Density" + (int)dPopulation.getFloat(i, 0), mouseX, mouseY);
      }
    }
  }



    


//====================================================================
// 柱状图
//====================================================================

  // 绘制坐标轴
  void drawAxisLabels() {
    fill(0);
    textSize(15);
    textLeading(15);


    rectMode(CENTER);    
    fill(baseColor);
    rect(labelX+33, plotY1 + 23, 12, 12);
    rectMode(CENTER);    
    fill(upperColor);
    rect(labelX+33, plotY1 + 58, 12, 12);
    
    textAlign(LEFT, CENTER);
    fill(fontColor);
    text("Population", labelX+50, plotY1 + 20);
    text("Daytime\n Population", labelX+50, plotY1 + 55);
    
    textAlign(RIGHT, CENTER);
    text("Population", plotX1 - 5, plotY1 + 20);
    textAlign(CENTER);
    text("Zone", plotX2 - 30, plotY2+20);
  }
  

  // 绘制人口标签（Y轴）
  void drawPopulationLabels() {
    fill(0);
    textSize(10);
    textAlign(RIGHT);
    
    stroke(128);
    strokeWeight(1);
    
    for (float v = pDataMin; v <= pDataMax; v+= popIntervalMinor) {
      if (v % popIntervalMinor == 0) {
        float y = map(v, pDataMin, pDataMax, plotY2, plotY1+70);
        println("popIntervalMinor v = " + v);

        if (v % popInterval == 0) {
          float textOffset = textAscent()/2;
          println("popInterval v = " + v);

          if (v == pDataMin) {
            textOffset = 0;                   // Align by the bottom
          } else if (v == pDataMax) {
            textOffset = textAscent();        // Align by the top
          }
          text(floor(v), plotX1 - 10, y + textOffset/3);

          line(plotX1 - 4, y, plotX1, y);     // Draw major tick
        }
      }
    }
  }

  // 绘制地区标签（X轴）
  void drawZoneLabels() {
    fill(0);
    textSize(10);
    textAlign(CENTER);
    
    stroke(224);
    strokeWeight(1);
    
    float drawX = plotX1;

    for (int row = 0; row < dPopRowCount; row++) {
      drawX += 70;
      text(dPopulation.zoneNames[row], drawX, plotY2+textAscent()+10);
      line(drawX, plotY1, drawX, plotY2);
    }

  }

  // 绘制数据
  void drawDataArea() {
    float x = 70;
    int tempRow;
    smooth();

    int[][] sortedData = new int[dPopRowCount][dPopColumnCount];
    sortedData = sort_reverse(dPopulation.data);
    
    for (int row = 0; row < dPopRowCount; row++) {
      if (dPopulation.isValid(row, 0)) {


        // float value = dPopulation.getFloat(row, 0);
        float value = sortedData[row][0];
        x += 70;
        float y = map(value, pDataMin, pDataMax, plotY2, plotY1+70);
        tempRow = row;
        
        fill(baseColor);
        noStroke();
        rectMode(CORNERS);
        rect(x-12, plotY2, x+32, y);
        
        textAlign(CENTER, BOTTOM);
        textSize(12);
        text(parseInt(value), x+10, y);
        
        if(mouseX > x-12 && mouseX < x+32){
          if(mouseY < plotY2+2 && mouseY > y-2){
            drawDayDataArea(x, tempRow);
          }
        }
        
      }
    } 
  }
  
  // 绘制白天的数据（基于总数据的绘制基础上）
  void drawDayDataArea(float x, int tempRow) {
    int[][] sortedData2 = sort_reverse2(dPopulation.data);

    float value = sortedData2[tempRow][1];
    float tempY = map(value, pDataMin, pDataMax, plotY2, plotY1+70);
    
    fill(upperColor);
    rect(x-12, plotY2, x+32, tempY);
    textAlign(CENTER, BOTTOM);
    textSize(12);
    fill(240);
    text((int)value, x+10, tempY+20);
    
    
  }
  
  // 拓展功能：单独绘制白天的数据
  void drawDayDataArea_Solo(float x, int tempRow) {
      
  }

//====================================================================
// 算法相关
//====================================================================

  // 排序算法 - 从小到大（数组默认是传址类型的,所以新建一个出来）
  public int[][] sort(int[][] a)  {
    int temp = 0;

    int[][] b = new int[dPopRowCount][dPopColumnCount];
    b = a;
    
    for(int i = dPopRowCount-1; i>0; --i) {
      for(int j = 0; j < i; ++j) {
        if(b[j+1][0] < b[j][0]) {
          temp      = b[j][0];
          b[j][0]   = b[j+1][0];
          b[j+1][0] = temp;
        }
      }
    }
    return b;
  }

  // 排序算法 - 从大到小
  public int[][] sort_reverse(int[][] a)  {
    int temp = 0;
    int[][] b = new int[dPopRowCount][dPopColumnCount];
    b = a;

    String[] myZoneNames = new String[dPopRowCount];
    myZoneNames = dPopulation.zoneNames;
    String tempString = " ";
    
    for(int i = dPopRowCount-1; i>0; --i) {
      for(int j = 0; j < i; ++j) {
        if(b[j+1][0] > b[j][0]) {
          temp      = b[j][0];
          b[j][0]   = b[j+1][0];
          b[j+1][0] = temp;
          
          tempString      = myZoneNames[j];
          myZoneNames[j]   = myZoneNames[j+1];
          myZoneNames[j+1] = tempString;
          
        }
      }
    }
    
    return b;
  }

  // 排序算法 - 白天数据的从大到小
  public int[][] sort_reverse2(int[][] a)  {
    int temp = 0;
    int[][] b = new int[dPopRowCount][dPopColumnCount];
    b = a;
    
    for(int i = dPopRowCount-1; i>0; --i) {
      for(int j = 0; j < i; ++j) {
        if(b[j+1][1] > b[j][1]) {
          temp      = b[j][1];
          b[j][1]   = b[j+1][1];
          b[j+1][1] = temp;
          
        }
      }
    }
    
    return b;
  }
  


  // 检测是否在扇形内
  private boolean mouseIsInArc(int i, float[] endAngle){
    mousePos = new PVector(mouseX, mouseY);
    PVector corePos = new PVector(coreX, coreY);
    PVector beginPoint = new PVector(0, coreR);
    PVector tempV;
    tempV = new PVector(mouseX-coreX, mouseY-coreY);
    
    float deltaAngle;
    
    if (dist(mousePos.x, mousePos.y, corePos.x, corePos.y) <= coreR){
      
      if (mouseX > coreX){
        deltaAngle = PI - PVector.angleBetween(tempV, beginPoint);
        println("angle = " + deltaAngle/PI);
        
      } else {
        deltaAngle = PI + PVector.angleBetween(tempV, beginPoint);
        println("angle = " + deltaAngle/PI);
      }
      
      if (deltaAngle > endAngle[i]+HALF_PI && deltaAngle < endAngle[i+1]+HALF_PI){
        //println("angle: " + PVector.angleBetween(tempV, beginPoint)/PI);
        
        return true;

      } else return false;
    } else return false;
  }

  // 检测是否在扇形内2
  private boolean mouseIsInArc2(int i, float[] endAngle){
    mousePos = new PVector(mouseX, mouseY);
    PVector corePos = new PVector(coreX2, coreY2);
    PVector beginPoint = new PVector(0, coreR2);
    PVector tempV;
    tempV = new PVector(mouseX-coreX2, mouseY-coreY2);
    
    float deltaAngle;
    
    if (dist(mousePos.x, mousePos.y, corePos.x, corePos.y) <= coreR){
      
      if (mouseX > coreX2){
        deltaAngle = PI - PVector.angleBetween(tempV, beginPoint);
        println("angle = " + deltaAngle/PI);
        
      } else {
        deltaAngle = PI + PVector.angleBetween(tempV, beginPoint);
        println("angle = " + deltaAngle/PI);
      }
      
      if (deltaAngle > endAngle[i]+HALF_PI && deltaAngle < endAngle[i+1]+HALF_PI){
        //println("angle: " + PVector.angleBetween(tempV, beginPoint)/PI);
        
        return true;

      } else return false;
    } else return false;
  }


}
