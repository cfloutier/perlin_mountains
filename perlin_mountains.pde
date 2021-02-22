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

  data.LoadJson("./Saved/default.json");

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

  
  if (record) 
  {

    String name = data.name;
    if (name == "")
      name = "Perlin_Mountain";
      
    float sizeMultiplier = 1000;
      
      sizeMultiplier = (float)width  / 28;
      
      
    float newWidth = width * sizeMultiplier;
    float newheight = height * sizeMultiplier;
    
    
      
      
      
      

    fileName = "Export/"+ name + "_" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second(); 
    if (mode == 0)
       current_graphics = createGraphics((int)newWidth, (int)newheight, PDF, fileName+ ".pdf");       
    else if (mode == 1)
      current_graphics = createGraphics((int)newWidth, (int)newheight, DXF, fileName+ ".dxf");       
    else if (mode ==2)
      current_graphics = createGraphics((int)newWidth, (int)newheight, SVG, fileName+ ".svg");       
    
    data.setSize(newWidth, newheight); 
    
    current_graphics.beginDraw();
    current_graphics.strokeWeight(data.style.lineWidth*sizeMultiplier);
    
  } else {
    
    current_graphics = g;

    background(data.style.backgroundColor);
    strokeWeight(data.style.lineWidth);
    
    
    
    stroke(data.style.lineColor);
    
    current_graphics = g;

    data.setSize(width, height);
  } 


  if (data.changed)
  {
    dataGui.updateUI();
  }

  drawer.data = data;
  drawer.draw();

  if (record) 
  {
    current_graphics.dispose();
    current_graphics.endDraw();
    record = false;
  }
}
