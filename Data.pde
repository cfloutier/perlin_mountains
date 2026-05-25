import controlP5.*;  

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
  }
}

class DataGUI extends MainPanel
{
  PerlinMountainsData data;

  FileGUI file_ui;
  MainGUI main_ui;
  StyleGUI style_ui;
  LayersGui layers_ui;

  public DataGUI(PerlinMountainsData data)
  {
    this.data = data;

    file_ui = new FileGUI(data);
    main_ui = new MainGUI(data.main); 
    layers_ui = new LayersGui(data.layers); 
    style_ui = new StyleGUI(data.style); 
  }

  void Init()
  {
    addTab(file_ui);
    addTab(style_ui);
    addTab(main_ui);
    addTab(layers_ui);
    
    super.Init();

    cp5.getTab("Main").bringToFront();
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
      
      float move_x =  0.001*key_move.x * delta_ms * data.main.moveSpeed_X;
      float move_y =  0.001*key_move.y * delta_ms * data.main.moveSpeed_Y;
  
      for (int i = 0 ; i < data.layers.count(); i++)
      {
        DataLayer layer = data.layers.layer(i);
        layer.pos_x += move_x * layer.pow_X();  
        layer.pos_y += move_y * layer.pow_Y();
      }
      
      data.layers.apply_to_edit();

      return true;
    }
    
    return false;
  }

  PVector last_mouse_pos = null;

  void mousePressed()
  {
    if (cp5.isMouseOver())
      return;
      
    layers_ui.on_start_drag();
  }
  
  void mouseDragged()
  {
    layers_ui.on_drag();
  }

  void mouseReleased() {
    layers_ui.end_drag();
   
  }


}
