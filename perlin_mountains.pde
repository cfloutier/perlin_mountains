import controlP5.*; //<>//
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;


DrawingData data;


DataGUI dataGui;

PGraphics current_graphics;
DrawingGenerator drawer;
ControlP5 cp5;

void setup() 
{
  size(1200, 800);

  drawer =  new DrawingGenerator();
  data = new DrawingData();
  dataGui = new DataGUI();

  setupControls();

  data.LoadJson("./Saved/few islands.json");
  data.name = "few islands";

  dataGui.setGUIValues();


  surface.setResizable(true);

  //noLoop();  // Run once and stop
}

void setupControls()
{ 
  cp5 = new ControlP5(this);
  cp5.getTab("default").setLabel("Hide GUI");
  dataGui.setupControls( cp5 );    
  addFileTab();
}

void draw()
{
  start_draw();

  if (data.changed)
  {
    dataGui.updateUI();
  }

  drawer.data = data;
  drawer.draw();

  end_draw();
}
