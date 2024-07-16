import controlP5.*;  //<>//


class Data
{
  String name = "";

  boolean changed = true;
  
  String tab_name;
  PVector move = new PVector(0, 0);

  Style style = new Style();
  DataMain main = new DataMain();  
  DataLayer Noise1 = new DataLayer();
  DataLayer Noise2 = new DataLayer();
  DataLayer Noise3 = new DataLayer();
  
  float width = 800;
  float height = 600;

  void setSize(float width, float height)
  {
    if (this.width != width)
    {
      changed = true;
      this.width = width;
    }

    if (this.height != height)
    {
      changed = true;
      this.height = height;
    }
  }

  void LoadJson(String path)
  {
    JSONObject json = loadJSONObject(path);

    style.LoadJson(json.getJSONObject("Style"));
    main.LoadJson(json.getJSONObject("Main"));

    Noise1.LoadJson(json.getJSONObject("Noise1"));
    Noise2.LoadJson(json.getJSONObject("Noise2"));
    Noise3.LoadJson(json.getJSONObject("Noise3"));

    style.LoadJson(json.getJSONObject("Style"));
  }

  void SaveJson(String path)
  {
    JSONObject json = new JSONObject();

    json.setJSONObject("Noise1", Noise1.SaveJson());
    json.setJSONObject("Noise2", Noise2.SaveJson());
    json.setJSONObject("Noise3", Noise3.SaveJson());
    json.setJSONObject("Style", style.SaveJson());
    json.setJSONObject("Main", main.SaveJson());

    saveJSONObject(json, path);
  }
}



class DataGUI 
{
  LayerGui Noise1;
  LayerGui Noise2;
  LayerGui Noise3;
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
    Noise3.update();
  }

  void setupControls(ControlP5 cp5)
  { 
    cp5.addTab("Style");
    cp5.addTab("Main");

    cp5.addTab("Noise1");
    cp5.addTab("Noise2");
    cp5.addTab("Noise3");

    main.setupControls( cp5 );    
    style.setupControls( cp5 );    

    Noise1 = new LayerGui(data.Noise1, "Layer 1");
    Noise1.setupControls("Noise1", cp5);

    Noise2 = new LayerGui(data.Noise2, "Layer 2");
    Noise2.setupControls("Noise2", cp5);
    
    Noise3 = new LayerGui(data.Noise3, "Layer 3");
    Noise3.setupControls("Noise3", cp5);

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
