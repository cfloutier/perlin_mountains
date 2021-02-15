import controlP5.*; //<>// //<>//


class DataGUI extends UI_Panel 
{

  Slider NbLines;
  Slider XSteps;
  Slider Height;

 
  LayerGui Noise1;
  LayerGui Noise2;

  Slider moveSpeed;

  Toggle intersection;

  void setupControls(ControlP5 cp5)
  { 
    super.Init("Controls", cp5);

    NbLines = addSlider("NbLines", data, 1, 1000, true);
    XSteps = addSlider("XSteps", data, 20, 2000, false);  
    Height = addSlider("Height", data, 0, 1, false);

    yPos+=10;
    
    Noise1 = new LayerGui(data.Noise1);
    Noise1.setupControls(this);
    
    Noise2 = new LayerGui(data.Noise2);
    Noise2.setupControls(this);

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
    
    Noise2.setGUIValues();
    Noise1.setGUIValues();

    intersection.setValue(data.intersection);
    moveSpeed.setValue(data.moveSpeed);
  }
}
