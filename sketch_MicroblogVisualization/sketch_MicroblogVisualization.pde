// Hello ! 
// first step: show the map;
// second step: deal with the data;

Visualization_Population vPopulation;

void setup() {
  
  smooth();
  noStroke();
  frameRate(35);
  
  size(1180, 600);
  
  vPopulation = new Visualization_Population();
  
}

void draw() {
  background(255);
  
  
  vPopulation.draw();
  
}


