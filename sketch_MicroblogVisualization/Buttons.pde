class Buttons{

  color cChosen, cUnchosen;
  int iBX, iBY;
  int iBR;
  
  Buttons() {
    cChosen = color(44, 198, 240);
    cUnchosen = color(200, 200, 200);
    
    iBX = width/2;
    iBY = height - 30;
    iBR = 8;
    
  }
  
  void draw() {
    noStroke();
    ellipseMode(RADIUS);
    
    fill(0 == vFlag ? cChosen : cUnchosen);
    ellipse(iBX - 30, iBY, iBR, iBR);
    
    fill(1 == vFlag ? cChosen : cUnchosen);
    ellipse(iBX, iBY, iBR, iBR);
    
    fill(2 == vFlag ? cChosen : cUnchosen);
    ellipse(iBX + 30, iBY, iBR, iBR);
    
  }

  int getX0() {    return iBX - 30;  }
  int getX1() {    return iBX;  }
  int getX2() {    return iBX + 30;  }

  int getY() {    return iBY;  }
  
  int getR() {    return iBR;  }

}
