
PopulationTable dPopulation;
float maxPop, maxPopRadius;

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
    maxPopRadius = 40 / maxPop;
    
    pDataMin = 0;
    // get the intdata
    pDataMax = ceil(dPopulation.getMaxPopulation() / popInterval) * popInterval;
    pDayDataMax = ceil(dPopulation.getMaxDaytimePopulation() / popInterval) * popInterval;
    

    plotFont = createFont("SansSerif", 20);
    textFont(plotFont);
    color fontColor = color(0);
    
    pFlag = 0;
  }
  
  void draw(){
    // image(iMap, 0, 0, width, height);
    
    ellipseMode(RADIUS);
    
    fill(200, 200, 200, 210);
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    drawAxisLabels();
    drawZoneLabels();
    drawPopulationLabels();
    drawDataArea();
    drawTitle();
  }

  void drawChart1() {

    drawAxisLabels();
    drawZoneLabels();
    drawPopulationLabels();
    drawDataArea();
    drawTitle();

  }

  void drawChart2() {

    drawAxisLabels();
    drawZoneLabels();
    drawPopulationLabels();
    drawDataArea();
    drawTitle();
    
  }

  
  void drawTitle() {
    fill(0);
    textSize(20);
    textAlign(CENTER);
    String title = dPopulation.getColumnName(0);
    text(title, (plotX1 + plotX2)/2, plotY1 - 10);
  }

  color baseColor = color(251, 168, 70);
  color upperColor = color(244, 106, 5);

  void drawPopulationCookie(){

    fill(200, 200, 200, 210);
    ellipse(width/2, height/2, maxPop * maxPopRadius, maxPop * maxPopRadius);

  }

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
        
        fill(200);
        noStroke();
        rectMode(CORNERS);
        rect(x, plotY2, x+20, y);
        
        
        if(mouseX > x-2 && mouseX < x+22){
          //if(mouseY > plotY2+2 && mouseY < y-2){
            drawDayDataArea(x, tempRow);
            println("Hit!");
          //}
        }
      }
    }
    // Draw the lower-right and lower-left corners
    
  }
  
  void drawDayDataArea(float x, int tempRow) {
    float value = dPopulation.getFloat(tempRow, 1);
    float tempY = map(value, pDataMin, pDayDataMax, plotY2, plotY1+70);
    
    fill(200, 50, 80);
    rect(x, plotY2, x+20, tempY);
    textAlign(LEFT, BOTTOM);
    text(dPopulation.getFloat(tempRow, 1), x, tempY);
    
    // Draw the lower-right and lower-left corners
    
  }


}
