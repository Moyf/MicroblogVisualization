// Hello ! 
// first step: show the map.

PImage mapImage;

void setup() {
  
  smooth();
  noStroke();
  frameRate(25);
  
  size(1180, 600);
  mapImage = loadImage("Vastopolis_Map.png");
  
}

void draw() {
  background(255);
  image(mapImage, 0, 0, width, height);
  
  
  // =========================//
  // TEST: draw a circle.
  // =========================//
  
  // para 1&2 is position, 3&4 is width(height)/2
  ellipseMode(RADIUS);
  
  fill(192, 0, 0, 60);
  ellipse(width/2, height/2, 50, 50);
  
}
