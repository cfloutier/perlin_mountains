import controlP5.*; //<>//
import processing.pdf.*;
import processing.dxf.*;
import processing.svg.*;


DrawingData data;
DataGUI dataGui;
DrawingGenerator drawer;

ControlP5 cp5;

void setup() 
{
  size(1200, 800);

  drawer =  new DrawingGenerator();
  data = new DrawingData();
  dataGui = new DataGUI();

  setupControls();

  surface.setResizable(true);

  //noLoop();  // Run once and stop
}

void setupControls()
{ 
  cp5 = new ControlP5(this);

  cp5.addTab("Controls");
  cp5.getTab("default").setLabel("Hide GUI");

  dataGui.setupControls( cp5 );     
  dataGui.setGUIValues(new DrawingData());

  addFileTab();
  
  cp5.getTab("Controls").bringToFront();
}

void draw()
{
  background(0);

  if (record) 
  {
    // Note that #### will be replaced with the frame number. Fancy!

    fileName = "Export/Mountain_" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second(); 
    if (mode == 0)
      beginRecord(PDF, fileName + ".pdf"); 
    else if (mode == 1)
      beginRecord(DXF, fileName + ".dxf"); 
    else if (mode ==2)
      beginRecord(SVG, fileName + ".svg"); 

    stroke(0);
  } else
    stroke(255);

    drawer.data = data;
    drawer.draw();
  
  if (record) 
  {
    endRecord();
    record = false;
  }
}
