
PopulationTable dPopulation;
float maxPop, maxPopRadius;
float sumPop, sumPopRadius;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int popInterval = 50000;
float pDataMin, pDataMax, pDayDataMax;

PFont plotFont; 

int pFlag;
color fontColor;

class Visualization_Population {

  
  Visualization_Population() {
    iMap = loadImage("Vastopolis_Map.png");
    
    dPopulation = new PopulationTable("Population.csv");
    dPopulation.showData();
    
    plotX1 = 80; 
    plotX2 = width - plotX1;
    labelX = plotX2 - 150;
    plotY1 = 60;
    plotY2 = height - plotY1-30;
    labelY = height - 25;

    image(iMap, 0, 0, width, height);
    
    maxPop = dPopulation.getMaxPopulation();
    maxPopRadius = 400 / maxPop;
    
    sumPop = dPopulation.getSumPopulation();
    sumPopRadius = 1220 / sumPop ;
    
    pDataMin = 0;
    // get the intdata
    pDataMax = dPopulation.getMaxPopulation(); //ceil(dPopulation.getMaxPopulation() / popInterval) * popInterval;
    pDayDataMax = dPopulation.getMaxDaytimePopulation(); //ceil(dPopulation.getMaxDaytimePopulation() / popInterval) * popInterval;
    

    plotFont = createFont("SansSerif", 20);
    textFont(plotFont);
    color fontColor = color(0);
    
    pFlag = 0;
  }
  
  void draw(){
    if(pFlag == 0) drawChart1();
    else 
    if (pFlag == 1){
      drawChart2();
    }
  }

  void drawChart1() {
    drawPopulationCookie();
    
  }

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


// ========================================================
// 饼图
// ========================================================
  void drawPopulationCookie(){
    
    float tempEnd = -HALF_PI;  

    fill(baseColor);
    ellipseMode(CENTER);
    // ellipse(width/2, height/2, 300, 300);
    

    for (int row = 0; row < dPopulation.rowCount; row++) {
      if (dPopulation.isValid(row, 0)) {
        
        float percent = dPopulation.getFloat(row, 0)/sumPop;
        println("tempEnd now is: " + tempEnd/PI);

        
        fill(100, 100 + 5 * row, 55);
        // stroke(100);
        arc(width/2, height/2, 300, 300, tempEnd, tempEnd + percent * TWO_PI, PIE);
        tempEnd += percent * TWO_PI;
        // text(dPopulation.getFloat(row, 0), mouseX, mouseY);
//        fill(255, 20, 20);
//        arc(width/2, height/2, 300, 300, -HALF_PI, PI/100, PIE);
    

      }
    }
  }


// ========================================================
// 柱状图
// ========================================================

  void drawAxisLabels() {
    fill(0);
    textSize(15);
    textLeading(15);

//    ellipseMode(CENTER);
//    ellipse(labelX-20, plotY1 + 40, 12, 12);
//    ellipseMode(CENTER);
//    ellipse(labelX-20, plotY1 + 65, 12, 12);
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
  


  int popIntervalMinor = 10000;   
  // Add this above setup()

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


  void drawZoneLabels() {
    fill(0);
    textSize(10);
    textAlign(CENTER);
    
    // Use thin, gray lines to draw the grid
    stroke(224);
    strokeWeight(1);
    
    float drawX = plotX1;

    for (int row = 0; row < dPopulation.rowCount; row++) {
      // float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      drawX += 70;
      text(dPopulation.zoneNames[row], drawX, plotY2 + textAscent() + 10);
      line(drawX, plotY1, drawX, plotY2);
    }

  }

  void drawDataArea() {
    float x = 70;
    int tempRow;
    smooth();
    for (int row = 0; row < dPopulation.rowCount; row++) {
      if (dPopulation.isValid(row, 1)) {
        float value = dPopulation.getFloat(row, 0);
        x += 70;
        println("pDataMax = " + pDataMax);
        float y = map(value, pDataMin, pDataMax, plotY2, plotY1+70);
        tempRow = row;
        
        fill(baseColor);
        noStroke();
        rectMode(CORNERS);
        rect(x-12, plotY2, x+32, y);
        
        textAlign(CENTER, BOTTOM);
        textSize(15);
        text(parseInt(value), x+10, y);
        
        if(mouseX > x-2 && mouseX < x+22){
          if(mouseY < plotY2+2 && mouseY > y-2){
            drawDayDataArea(x, tempRow);
            println("Hit!");
            println("x: "+ x + ", y=" + y + ", plotY2=" + plotY2);
            println("pDataMin: "+ pDataMin + ", pDataMax=" + pDataMax);
          }
        }
      }
    }
  }
  
  void drawDayDataArea(float x, int tempRow) {
    float value = dPopulation.getFloat(tempRow, 1);
    float tempY = map(value, pDataMin, pDataMax, plotY2, plotY1+70);
    int tempValue = parseInt(value);
    
    fill(upperColor);
    rect(x-12, plotY2, x+32, tempY);
    textAlign(CENTER, BOTTOM);
    textSize(15);
    text(tempValue, x+10, tempY);
    
    // Draw the lower-right and lower-left corners
    
  }
  
  void drawDayDataArea_Solo(float x, int tempRow) {
      // Draw the lower-right and lower-left corners
      
  }
  



}
