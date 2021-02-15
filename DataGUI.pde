import controlP5.*; //<>// //<>//


class DataGUI extends UI_Panel 
{

 
  Slider NbLines;
  Slider XSteps;
  Slider Height;

  Slider xNoise1;
  Slider xNoise2;
  Slider xNoise3;
  
  LayerGui layer_1;
  

  Slider yNoise1;
  Slider yNoise2;
  Slider yNoise3;

  Slider HeightLine1;
  Slider HeightLine3;
  Slider HeightLine2;

  Slider moveSpeed;

  Toggle intersection;

 

  void setupControls(ControlP5 cp5)
  { 
    super.Init("Controls", cp5);

    NbLines = addSlider("NbLines", data, 1, 1000, true);
    XSteps = addSlider("XSteps", data, 20, 2000, false);  
    Height = addSlider("Height", data, 0, 1, false);

    yPos+=10;
    
    layer_1 = new LayerGui(data.Noise1);
    layer_1.setupControls(this);

    xNoise1 = addSlider("xNoise1", data, 0, 10, true);
    xNoise2 = addSlider("xNoise2", data, 0, 50, false);

    yNoise1 = addSlider("yNoise1", data, 0, 30, true);
    yNoise2 = addSlider("yNoise2", data, 0, 40, false);
    
    HeightLine1 = addSlider("HeightLine1", data, 0, 2000, true);
    HeightLine2 = addSlider("HeightLine2", data, 0, 100, false);

    xPos = 0;
    yPos+=10;

    moveSpeed = addSlider("moveSpeed", data, 0, 10, false);

    intersection = addToggle( "intersection", data);

    yPos+=heightCtrl;
  }
 
  void setGUIValues()
  {
    NbLines.setValue(data.NbLines);
    XSteps.setValue(data.XSteps);
    Height.setValue(data.Height);
    
    layer_1.setGUIValues();

    xNoise1.setValue(data.xNoise1);
    xNoise2.setValue(data.xNoise2);

    yNoise1.setValue(data.yNoise1);
    yNoise2.setValue(data.yNoise2);


    HeightLine1.setValue(data.HeightLine1);
    HeightLine2.setValue(data.HeightLine2);

    intersection.setValue(data.intersection);
    moveSpeed.setValue(data.moveSpeed);
  }
}
