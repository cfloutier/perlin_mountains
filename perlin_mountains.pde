import controlP5.*; //<>// //<>// //<>//
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;


PerlinMountainsData data;
DataGUI dataGui;

PGraphics current_graphics;
DrawingGenerator drawer;
ControlP5 cp5;

void setup() 
{
  size(1200, 800);

  drawer =  new DrawingGenerator();
  data = new PerlinMountainsData();
  dataGui = new DataGUI();

  setupControls();

  data.LoadSettings("./Settings/few islands.json");

  dataGui.setGUIValues();

  surface.setResizable(true);

  //noLoop();  // Run once and stop
}

void setupControls()
{ 
  cp5 = new ControlP5(this);
  cp5.getTab("default").setLabel("Hide GUI");
  addFileTab();
  dataGui.setupControls( cp5 );    
}

void draw()
{
  start_draw();

  // recenter
  pushMatrix();
  translate(width/2, height/2);
  scale(data.global_scale,data.global_scale);
  translate(-width/2, -height/2);

  if (data.changed)
  {
    dataGui.update_ui();
  }

  drawer.draw();

  popMatrix();
  end_draw();
}
