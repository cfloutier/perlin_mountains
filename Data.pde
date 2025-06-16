import controlP5.*;  //<>// //<>//

class PerlinMountainsData extends DataGlobal
{
  String tab_name;
  PVector move = new PVector(0, 0);
  
  Style style = new Style();
  DataMain main = new DataMain();  
  DataLayers layers = new DataLayers();

  PerlinMountainsData()
  {
    addChapter(main);
    addChapter(style);
    addChapter(layers); 
  }

  void reset()
  {
    main.CopyFrom(new DataMain());
    style.CopyFrom(new Style());

    // needed to be reset it's proper way
    layers.reset();
  }
  
  void LoadSettings(String path)
  {
    super.LoadSettings(path);
    
    // reset the indexes
    
  }
}

class DataGUI  extends MainPanel
{
  DataGlobal data;

  MainGUI main_ui;
  StyleGUI style_ui;
  LayersGui layers_ui;

  public DataGUI(PerlinMountainsData data)
  {
    this.data = data;

    main_ui = new MainGUI(data.main); 
    layers_ui = new LayersGui(data.layers); 
    style_ui = new StyleGUI(data.style); 
  }

  void Init()
  {
    addTab(main_ui);
    addTab(style_ui);
    addTab(layers_ui);
    super.Init();

    cp5.getTab("Layers").bringToFront();
  }  

  int last_update = -1;
  boolean checkKeyMove()
  {
    if (last_update == -1)
    {
      last_update =  millis();
      return false;
    }
    int delta_ms =  millis() - last_update;
    last_update =  millis();
   
    if (key_move.x != 0 || key_move.y != 0)
    {
      //println("mouse pressed " + mouseX);
      for (GUIPanel panel : panels)
      {
        if (!panel.tab.isActive())
          continue;
        // call active panel
        if (panel.key_move(key_move, delta_ms))
        {
          return true;
        }
      }
    }

    return false;
  }

}
