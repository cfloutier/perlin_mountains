 //<>//
class DrawingData
{
  Style style = new Style();

  String name = "";

  boolean changed = true;

  MainData main = new MainData();
  LayerData Noise1 = new LayerData();
  LayerData Noise2 = new LayerData();
  LayerData Noise3 = new LayerData();
  
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
