import controlP5.*;    
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;
import java.util.Locale;

PerlinMountainsData data;
DataGUI dataGui;

PGraphics current_graphics;
PerlinMountainGenerator generator;
ControlP5 cp5;

void setup() 
{
  size(1200, 800);
  pixelDensity(1);
  surface.setResizable(false);

  generator =  new PerlinMountainGenerator();
  data = new PerlinMountainsData();
  dataGui = new DataGUI(data);

  setupControls();
  file_ui.export_group = generator.group;

  data.LoadSettings("./Settings/default.json");
  dataGui.setGUIValues();
}

void setupControls()
{ 
  cp5 = new ControlP5(this);
  cp5.getTab("default").setLabel("Hide GUI");
  dataGui.Init();
}

void draw()
{
  if (generator.lines != null && generator.lines.size() > 0)
    file_ui.updateExportScale(generator.getBoundingBox());

  start_draw();
  translate(-data.main.Width/2, 0);
  generator.draw();
  end_draw();
}
