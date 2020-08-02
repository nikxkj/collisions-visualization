/*
 Unfolding Tutorial TWO created for DATT3935 Creative Data Visualization. 
 Adapted from Till Nagel's Unfolding workshop at RCA 2014. 
 
 This visualization first loads JSON data into local memory using the BikeStation class 
 
 Joel Ong 
 */
 
 /*
 Names: Kemdi Ikejiani, Vivien Hung
 
 This visualization represents the condition of fatal collisions in Toronto.
 The colour shifts from blue to red to indicate the years changing from 2007 - 2017.
 The more transparent the colour indicates the increase of weather-related vissual compromisation.
 The size indicates the number of offences the driver committed that contributed to the collision.
 (aggressive driving, running redlight, speeding and driving while intoxicated)
 
 */
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

int year;
float clrx;
float clry;
float clrz;
float alpha;

JSONArray values;

UnfoldingMap map;
int maxYears = 0; //to get max number for mapping values to a range

ArrayList<BikeStation> fatalCollisions = new ArrayList();  //create instance of BikeStations in local memory

//PImage img;

void setup() {
  size(800, 600,P2D);
  smooth();

   // Create interactive map centered around London
  map = new UnfoldingMap(this);
  map.zoomAndPanTo(12, new Location(43.6532, -79.3832));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  
  
  Table fatalColCSV = loadTable("Fatal_Collisions.csv", "header");
  for (TableRow fatalColRow : fatalColCSV.rows()) {
    // Create new empty object to store data
    BikeStation fatalCol = new BikeStation();
    
    
    //fatalCol.bikesAvailable = bikeStationRow.getInt("availableDocks");
    

    // Read data from CSV
    //bikeStation.id = bikeStationRow.getInt("YEAR");
    year = fatalColRow.getInt("YEAR");
    fatalCol.name = fatalColRow.getString("District");
    fatalCol.id = fatalColRow.getInt("YEAR");
    fatalCol.streetName = fatalColRow.getString("STREET1");
    float lat = fatalColRow.getFloat("LATITUDE");
    float lng = fatalColRow.getFloat("LONGITUDE");
    float visibility = fatalColRow.getFloat("VISIBILITY");
    fatalCol.visibility = fatalColRow.getString("VISIBILITY");
    String street1 = fatalColRow.getString("STREET1");
    
    int rankCounter=0;
    if (fatalColRow.getString("SPEEDING").equals("Yes")) {
      rankCounter++;
    }
    if (fatalColRow.getString("AG_DRIV").equals("Yes")) {
      rankCounter++;
    }
    if (fatalColRow.getString("REDLIGHT").equals("Yes")) {
      rankCounter++;
    }
    if (fatalColRow.getString("ALCOHOL").equals("Yes")) {
      rankCounter++;
    }
    fatalCol.rank = rankCounter;
    
    fatalCol.location = new Location(lat, lng);
    // Add to list of all bike stations
    fatalCollisions.add(fatalCol);
    
    maxYears = max(maxYears, fatalCol.id);

    // Debug Info
    //println("Added " + bikeStation.name + " with " + bikeStation.bikesAvailable + " bikes.";

    // Statistics (well, sort of)
    //maxBikesAvailable = max(maxBikesAvailable, fatalCol.bikesAvailable);
  }
  
}

void draw() {
  // Draw map and darken it a bit
  
   map.draw();
  fill(0, 100);
  rect(0, 0, width, height);
  noStroke();
  // Iterate over all bike stations
  for (BikeStation fatalCol : fatalCollisions) {
    // Convert geo locations to screen positions
    ScreenPosition pos = map.getScreenPosition(fatalCol.location);
    
    
    //float s = map(fatalCol.id, 2007, maxBikesAvailable, 1, 50);
    float val = map(fatalCol.id, 2007, 2017, 50, 200);
    float val2 = map(fatalCol.id, 2007, 2017, 200, 50);
    //fill(200, 40, 0, 200);
    if (fatalCol.visibility.equals ("Clear")) {
      alpha = 140;
    } else if (fatalCol.visibility.equals ("Rain")) {
      alpha = 120;
    } else if (fatalCol.visibility.equals ("Freezing Rain")) {
      alpha = 100;
    } else if (fatalCol.visibility.equals ("Snow")) {
      alpha = 80;
    } else if (fatalCol.visibility.equals ("Fog, Mist, Smoke, Dust")) {
      alpha = 60;
    }else {
      alpha = 40;
    }
    float size = map(fatalCol.rank,0, 4, 10, 70);
    /*if (fatalCol.id == 2007) {
      //clrx = 200;
      //clry = 100;
      //clrx
      fill(50, 0, 200, alpha);
    } else if (fatalCol.id == 2017) {
      fill(200, 0, 50, alpha);
    } else {
      fill(0, 200, 0, alpha);
    }*/
    fill(val, 0, val2, alpha);
    ellipse(pos.x, pos.y, size, size);
    
    
    // Map number of free bikes to radius of circle
    //float s = map(bikeStation.bikesAvailable, 0, maxBikesAvailable, 1, 50);
    // Draw circle according to available bikes
    
    //This is to save a label for Bikestation
     if (fatalCol.showLabel) {
      fill(240);
      String show = fatalCol.name + ": " + fatalCol.streetName;
      text(show, pos.x - textWidth(fatalCol.name)/2, pos.y);
    }
    
  }
}


//Get interactive by using Boolean variable 'showLabel'
void mouseClicked() {
  // Simple way of displaying bike station names. Use markers for single station selection.
  for (BikeStation bikeStation : fatalCollisions) {
    bikeStation.showLabel = false;
    ScreenPosition pos = map.getScreenPosition(bikeStation.location);
    if (dist(pos.x, pos.y, mouseX, mouseY) < 10) {
      bikeStation.showLabel = true;
    }
  }
}
