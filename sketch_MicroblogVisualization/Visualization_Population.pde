//====================================================================
// Data Visualization: Draw Charts of population of various zones.
//
// Auther: Moy
// Date  : 2014/6/15
//
//====================================================================


PopulationTable dPopulation;
float maxPop, maxPopRadius;
float sumPop, sumPopRadius;
int dPopRowCount, dPopColumnCount;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int popInterval = 50000;
int popIntervalMinor = 10000;
float pDataMin, pDataMax, pDayDataMax;

PFont plotFont; 

int pFlag;
color fontColor;

class Visualization_Population {
  
  Visualization_Population() {
    iMap = loadImage("Vastopolis_Map.png");
    
    dPopulation = new PopulationTable("Population.csv");
    dPopRowCount = dPopulation.rowCount;
    dPopColumnCount = dPopulation.columnCount;
    
    plotX1 = 80; 
    plotX2 = width - plotX1;
    labelX = plotX2 - 150;
    plotY1 = 60;
    plotY2 = height - plotY1-30;
    labelY = height - 25;

    image(iMap, 0, 0, width, height);
    
    maxPop = dPopulation.getMaxPopulation();
    maxPopRadius = 700 / maxPop;
    
    sumPop = dPopulation.getSumPopulation();
    sumPopRadius = 1520 / sumPop ;
    
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
    if(pFlag == 0) drawChart1();
    else 
    if (pFlag == 1){
      colorMode(RGB);
      drawChart2();
    }
  }

  // 图表一: 饼图
  void drawChart1() {
    drawTitle();
    drawPopulationCookie();
    
  }

  // 图表二: 柱状图
  void drawChart2() {

    fill(200, 200, 200, 210);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    drawAxisLabels();
    drawTitle();

    drawZoneLabels();
    drawPopulationLabels();
    drawDataArea();
    
  }

  
  void drawTitle() {
    fill(0);
    textSize(20);
    textAlign(CENTER);
    String title = dPopulation.getColumnName(0);
    text(title, (plotX1 + plotX2)/2, plotY1 - 10);
  }

  color baseColor = color(102, 175, 106);
  color upperColor = color(246, 145, 29);


//====================================================================
// 饼图
//====================================================================

  void drawPopulationCookie(){
    
    float tempEnd = -HALF_PI;  

    colorMode(RGB);
    fill(baseColor);
    ellipseMode(CENTER);
    colorMode(HSB, 360, 100, 100);
    color[] pieColor = new color[dPopRowCount];
    
    for (int i = 0; i < dPopRowCount; i++) {
      // pieColor[i] = color(100 + 20*(i%4), 80 + 5*(i%7), 10);
      // pieColor[i] = color(26+(i%4)*3, 80 + 5*(i%3), 90);
      pieColor[i] = color(i*(360.0/dPopRowCount), 70-(i%5)*3, 90);
    
    
    }

    int[][] tempData = sort_reverse(dPopulation.data);

    for (int row = 0; row < dPopRowCount; row++) {
      
      float percent = tempData[row][0]/sumPop;
      // println("tempEnd now is: " + tempEnd/PI);

      smooth();
      fill(pieColor[row]);
      arc(width/2-250, height/2, 450, 450, tempEnd, tempEnd + percent * TWO_PI - PI/500, PIE);
      tempEnd += percent * TWO_PI;
  
    }
    colorMode(RGB);

/*
    for (int row = 0; row < dPopRowCount; row++) {
      if (dPopulation.isValid(row, 0)) {
        
        float percent = dPopulation.getFloat(row, 0)/sumPop;
        println("tempEnd now is: " + tempEnd/PI);

        
        fill(pieColor[row]);

        arc(width/2, height/2, 300, 300, tempEnd, tempEnd + percent * TWO_PI, PIE);
        tempEnd += percent * TWO_PI;
    

      }
    }
    
*/
  }


//====================================================================
// 柱状图
//====================================================================

  // 绘制坐标轴
  void drawAxisLabels() {
    colorMode(RGB, 255);
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
    float value = dPopulation.getFloat(tempRow, 1);
    float tempY = map(value, pDataMin, pDataMax, plotY2, plotY1+70);
    int tempValue = parseInt(value);
    
    fill(upperColor);
    rect(x-12, plotY2, x+32, tempY);
    textAlign(CENTER, BOTTOM);
    textSize(12);
    fill(240);
    text(tempValue, x+10, tempY+20);
    
    
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
    
    for(int i = dPopRowCount-1; i>0; --i) {
      for(int j = 0; j < i; ++j) {
        if(b[j+1][0] > b[j][0]) {
          temp      = b[j][0];
          b[j][0]   = b[j+1][0];
          b[j+1][0] = temp;
        }
      }
    }
    
    return b;
  }


}
