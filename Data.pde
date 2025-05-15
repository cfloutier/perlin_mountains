import controlP5.*;  //<>//



class PerlinMountainsData extends DataGlobal
{
  String tab_name;
  PVector move = new PVector(0, 0);
  
  Style style = new Style();
  DataMain main = new DataMain();  
  DataLayer Noise1 = new DataLayer("Noise1");
  DataLayer Noise2 = new DataLayer("Noise2");
  DataLayer Noise3 = new DataLayer("Noise3");


  PerlinMountainsData()
  {
      addChapter(main);
      addChapter(Noise1);
      addChapter(Noise2);
      addChapter(Noise3);    
      addChapter(style);
  }
}


class DataGUI 
{
  LayerGui Noise1;
  LayerGui Noise2;
  LayerGui Noise3;
  MainGUI main = new MainGUI(); 

  StyleGUI style = new StyleGUI();

  void update()
  {
    if (!data.changed)
      return;

    main.update();
    style.update();
    Noise1.update();
    Noise2.update();
    Noise3.update();
  }

  void setupControls(ControlP5 cp5)
  { 
    cp5.addTab("Style");
    cp5.addTab("Main");

    cp5.addTab("Noise1");
    cp5.addTab("Noise2");
    cp5.addTab("Noise3");

    main.setupControls( );    
    style.setupControls(  );    

    Noise1 = new LayerGui(data.Noise1, "Layer 1");
    Noise1.setupControls("Noise1");

    Noise2 = new LayerGui(data.Noise2, "Layer 2");
    Noise2.setupControls("Noise2");
    
    Noise3 = new LayerGui(data.Noise3, "Layer 3");
    Noise3.setupControls("Noise3");

    cp5.getTab("Main").bringToFront();
  }

  void setGUIValues()
  {
    Noise2.setGUIValues();
    Noise1.setGUIValues();
    Noise3.setGUIValues();
    style.setGUIValues();
    main.setGUIValues();
  }
}
