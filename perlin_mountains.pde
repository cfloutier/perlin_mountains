import controlP5.*;    
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;


PerlinMountainsData data;
DataGUI dataGui;

PGraphics current_graphics;
PerlinMountainGenerator generator;
ControlP5 cp5;

void setup() 
{
  size(1200, 800);
  pixelDensity(1);

  generator =  new PerlinMountainGenerator();
  data = new PerlinMountainsData();
  dataGui = new DataGUI(data);

  setupControls();

  data.LoadSettings("./Settings/default.json");
  dataGui.setGUIValues();
  surface.setResizable(true);

  //noLoop();  // Run once and stop
}

void setupControls()
{ 
  cp5 = new ControlP5(this);
  cp5.getTab("default").setLabel("Hide GUI");
  dataGui.Init();
}

void draw()
{
  start_draw();

  pushMatrix();
  scale(data.page.global_scale, data.page.global_scale);
  translate(-width/2,-height/2);

  if (data.changed)
  {
    dataGui.update_ui();
  }

  generator.draw();

  popMatrix();
  end_draw();
}
