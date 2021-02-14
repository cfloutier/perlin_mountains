import controlP5.*; //<>// //<>//


class DataGUI implements ControlListener 
{
  
  String pageName = "Controls";

  float xPos = 0;
  float yPos = 0;

  int xspace = 15;
  
  int widthCtrl = 300;
  int heightCtrl = 20;


  ControlP5 cp5;

  Slider NbLines;
  Slider XSteps;
  Slider Height;

  Slider xNoise1;
  Slider xNoise2;
  Slider xNoise3;

  Slider yNoise1;
  Slider yNoise2;
  Slider yNoise3;

  Slider HeightLine1;
  Slider HeightLine3;
  Slider HeightLine2;

  Slider moveSpeed;

  Toggle intersection;

  boolean changed = false;

  public void controlEvent(ControlEvent theEvent) {
    data.changed = true;
  }

  void setGUIValues(DrawingData data)
  {
    NbLines.setValue(data.NbLines);
    XSteps.setValue(data.XSteps);
    Height.setValue(data.Height);

    xNoise1.setValue(data.xNoise1);
    xNoise2.setValue(data.xNoise2);

    yNoise1.setValue(data.yNoise1);
    yNoise2.setValue(data.yNoise2);


    HeightLine1.setValue(data.HeightLine1);
    HeightLine2.setValue(data.HeightLine2);

    intersection.setValue(data.intersection);
    moveSpeed.setValue(data.moveSpeed);
  }

  Slider addSlider(String name, float min, float max, boolean horizontal)
  {
    Slider s = cp5.addSlider(data, name)   
      .setPosition(xPos, yPos)
      .setSize(widthCtrl, heightCtrl)
      .setRange(min, max)
      .moveTo(pageName);

    if (horizontal)
    {
      xPos += xspace + widthCtrl;
    } else
    {
      yPos+=heightCtrl+2;
      xPos = 0;
    }
    
    
    controlP5.Label l = s.getCaptionLabel();
    l.getStyle().marginTop = 0; //move upwards (relative to button size)
    l.getStyle().marginLeft = -55; //move to the right

    return s;
  }
  
  Toggle addToggle(String name)
  {
    
     Toggle t = cp5.addToggle(data, name)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)  
      .setMode(ControlP5.SWITCH)
      .moveTo(pageName);

    yPos+=heightCtrl+2;
   
    //t.setLabel("The Toggle Name");
    controlP5.Label l = t.getCaptionLabel();
    l.getStyle().marginTop = -heightCtrl + 2; //move upwards (relative to button size)
    l.getStyle().marginLeft = 10; //move to the right
    
    return t;
    
  }
  

  void setupControls(ControlP5 cp5)
  { 
    this.cp5 = cp5;

    cp5.addListener(this);

    yPos = 20;

    NbLines = addSlider("NbLines", 1, 1000, true);
    XSteps = addSlider("XSteps", 20, 2000, false);  
    Height = addSlider("Height", 0, 1, false);

    yPos+=10;

    xNoise1 = addSlider("xNoise1", 0, 10, true);
    xNoise2 = addSlider("xNoise2", 0, 50, false);

    yNoise1 = addSlider("yNoise1", 0, 30, true);
    yNoise2 = addSlider("yNoise2", 0, 40, false);
    
    HeightLine1 = addSlider("HeightLine1", 0, 2000, true);
    HeightLine2 = addSlider("HeightLine2", 0, 100, false);

    xPos = 0;
    yPos+=10;

    moveSpeed = addSlider("moveSpeed", 0, 10, false);

    intersection = addToggle( "intersection");

    yPos+=heightCtrl;
  }
}
