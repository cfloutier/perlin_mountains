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
  background(data.style.backgroundColor);
  strokeWeight(data.style.lineWidth);
  
  

  if (record) 
  {
    // Note that #### will be replaced with the frame number. Fancy!
    
    String name = data.name;
    if (name == "")
      name = "Perlin_Mountain";
    
    fileName = "Export/"+ name + "_" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second(); 
    if (mode == 0)
      beginRecord(PDF, fileName + ".pdf"); 
    else if (mode == 1)
      beginRecord(DXF, fileName + ".dxf"); 
    else if (mode ==2)
      beginRecord(SVG, fileName + ".svg"); 
      
     data.setSize(width, height); 

    stroke(0);
  } else
  {
    
    stroke(data.style.lineColor);
    
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
    endRecord();
    record = false;
  }
}
