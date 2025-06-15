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

    // needed to be reset it's proper way
    layers.reset();

    style.CopyFrom(new Style());
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


  int last_update = 0;
  boolean checkKeyMove()
  {
   /*   
      if (layer != null)
      {
        int delta_ms =  millis() - lastUpdate;
        layer.pos.x += 0.001*data.move.x * delta_ms * data.main.moveSpeed_X * layer.pow_X;
        layer.pos.y += 0.001*data.move.y * delta_ms  * data.main.moveSpeed_Y * layer.pow_Y;   
        
        println("layer.pos.x " + layer.pos.x);
      }
      
      last_update =  millis();
      
      return true;
   
    */
    return false;
  }

}
