import controlP5.*; //<>// //<>// //<>// //<>//


class DataGUI extends UI_Panel 
{
  LayerGui Noise1;
  LayerGui Noise2;
  MainGUI main = new MainGUI(); 

  StyleGUI style = new StyleGUI();



  void updateUI()
  {
    if (!data.changed)
      return;

    main.update();
    style.update();
    Noise1.update();
    Noise2.update();
  }

  void setupControls(ControlP5 cp5)
  { 
    cp5.addTab("Style");
    cp5.addTab("Main");
    cp5.addTab("Controls");

    super.Init("Controls", cp5);

    main.setupControls( cp5 );    
    style.setupControls( cp5 );    



    Noise1 = new LayerGui(data.Noise1, "Layer 1");
    Noise1.setupControls(this);

    Noise2 = new LayerGui(data.Noise2, "Layer 2");
    Noise2.setupControls(this);



    cp5.getTab("Main").bringToFront();
  }

  void setGUIValues()
  {
    Noise2.setGUIValues();
    Noise1.setGUIValues();
    style.setGUIValues();
    main.setGUIValues();
  }
}

class MainGUI extends UI_Panel
{
  MainData main;

  Slider NbLines;
  Slider XSteps;
  Slider Height;
  Slider seed;
  Slider moveSpeed;

  Toggle intersection;

  void setGUIValues()
  {
    NbLines.setValue(main.NbLines);
    XSteps.setValue(main.XSteps);
    Height.setValue(main.Height);
    seed.setValue(main.seed);

    intersection.setValue(main.intersection);
    moveSpeed.setValue(main.moveSpeed);
  }

  void setupControls(ControlP5 cp5)
  {
    super.Init("Main", cp5);
    
    main = data.main;

    NbLines = addSlider("NbLines", "Nb of Lines", main, 1, 1000, true);
    XSteps = addSlider("XSteps", "X Steps", main, 2, 2000, false);  

    seed  = addSlider("seed", "seed", main, 0, 1000000000, false);  

    Height = addSlider("Height", "Drawing Height", main, 0, 1, false);

    intersection = addToggle( "intersection", "intersection", main);

    moveSpeed = addSlider("moveSpeed", "Move Speed", main, 0, 10, false);
  }

  void update()
  {
  }
}


class StyleGUI extends UI_Panel
{
  Slider lineWidth;
  Style style;
  ColorPicker backgroundColor;
  ColorPicker lineColor;

  void setGUIValues()
  {
    lineWidth.setValue(style.lineWidth);
    backgroundColor.setColorValue(style.backgroundColor);
  }

  void setupControls(ControlP5 cp5)
  {
    style = data.style;
    super.Init("Style", cp5);
    lineWidth = addSlider("lineWidth", "Line Width", style, 0, 5, false);
    backgroundColor = addColor("backgroundColor", "background Color", style);  
    lineColor = addColor("lineColor", "line Color", style);
  }

  void update()
  {
    style.backgroundColor = backgroundColor.getColorValue();
    style.lineColor = lineColor.getColorValue();
  }
}
