// Hello ! 
// first step: show the map;
// second step: deal with the data;
PImage iMap;
int vFlag, flagCount;

Visualization_Population vPopulation;
Visualization_Microblog vMicroblog;
Buttons btns;

void setup() {
  
  smooth();
  noStroke();
  frameRate(35);
  
  size(1180, 600);
  
  vPopulation = new Visualization_Population();
  vMicroblog = new Visualization_Microblog();
  vFlag = 0;
  flagCount = 3;
  btns = new Buttons();
  
}

void draw() {
  background(255);
  
  switch(vFlag){
    case 0:
      vPopulation.draw();
      break;
    case 1:
      vMicroblog.draw();
      break;
    case 2:
      break;
    default:
      break;
    
  }
  
  btns.draw();
  
}

void mousePressed() {
  if (dist(btns.getX0(), btns.getY(), mouseX, mouseY) < btns.getR() + 2){
    vFlag = 0;
  } else if (dist(btns.getX1(), btns.getY(), mouseX, mouseY) < btns.getR() + 2){
    vFlag = 1;
  } else if (dist(btns.getX2(), btns.getY(), mouseX, mouseY) < btns.getR() + 2){
    vFlag = 2;
  }
  
  
}

void keyPressed() {
  if (key == '[') {
    vFlag--;
    if (vFlag < 0) vFlag = flagCount - 1;
  } else if (key == ']') {
    vFlag++;
    if (vFlag == flagCount) vFlag = 0;
    
  }


  if (key == CODED) { 
    if (keyCode == LEFT) { 
      vFlag--;
      if (vFlag < 0) vFlag = flagCount - 1;
      
    } else if (keyCode == RIGHT) { 
        vFlag++;
        if (vFlag == flagCount) vFlag = 0;
    } 
  } 



}





