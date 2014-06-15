
PImage iTF1, iTF2;

class Visualization_Textflow {

  Visualization_Textflow() {
    iTF1 = loadImage("suburbia.jpg");
    iTF2 = loadImage("villa.jpg");
    
  }
  
  void draw(){
    image(iTF1, 80, 100, 570, 400);
    image(iTF2, 720, 50, 350, 500);
    
    
  }
  
  
}
