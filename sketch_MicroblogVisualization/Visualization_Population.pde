PImage iMap;
PopulationTable dPopulation;
float maxPop, maxPopRadius;

class Visualization_Population {

  
  Visualization_Population() {
    iMap = loadImage("Vastopolis_Map.png");
    
    dPopulation = new PopulationTable("Population.csv");
    dPopulation.showData();
    
    image(iMap, 0, 0, width, height);
    
    maxPop = dPopulation.getMaxPopulation();
    maxPopRadius = 40 / maxPop;
  
  }
  
  void draw(){
    image(iMap, 0, 0, width, height);
    
    ellipseMode(RADIUS);
  
    fill(200, 200, 200, 210);
    ellipse(100, 200, maxPop * maxPopRadius, maxPop * maxPopRadius);
    
    
  }
  
  
}
