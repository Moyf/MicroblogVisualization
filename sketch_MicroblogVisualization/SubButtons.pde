class SubButtons{

  color cChosen, cUnchosen;
  int iBX, iBY;
  int iBW, iBH;
  
  SubButtons() {
    cChosen = color(198, 80, 240);
    cUnchosen = color(200, 200, 200);
    
    iBX = width-20;
    iBY = height - 100;
    iBW = 12;
    iBH = 5;
    
  }
  
  void draw() {
    noStroke();
    rectMode(CORNER);
    
    fill(0 == pFlag ? cChosen : cUnchosen);
    rect(iBX - 30, iBY, iBW, iBH);
    
    fill(1 == pFlag ? cChosen : cUnchosen);
    rect(iBX - 30, iBY+10, iBW, iBH);
    
    fill(130, 100, 120);
    textSize(14);
    textAlign(RIGHT, BOTTOM);
    text("Use <UP> and <DOWN> to shift charts", width - 170, 55);
  }

}
