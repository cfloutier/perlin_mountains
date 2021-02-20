import controlP5.*; //<>// //<>// //<>// //<>//


class DataGUI 
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

    cp5.addTab("Noise1");
    cp5.addTab("Noise2");

    main.setupControls( cp5 );    
    style.setupControls( cp5 );    

    Noise1 = new LayerGui(data.Noise1, "Layer 1");
    Noise1.setupControls("Noise1", cp5);

    Noise2 = new LayerGui(data.Noise2, "Layer 2");
    Noise2.setupControls("Noise2", cp5);

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
