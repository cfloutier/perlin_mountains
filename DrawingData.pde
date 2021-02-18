 //<>//
class DrawingData
{
  String name = "";
  
  boolean changed = true;

  PVector pos = new PVector(0, 0);

  int NbLines = 100;

  int XSteps = 300;
  float Height = 0.5;
  
  int seed; 
  boolean intersection = true;

  LayerData Noise1 = new LayerData();
  LayerData Noise2 = new LayerData();


  float moveSpeed = 1;
  PVector move = new PVector(0, 0);

  void LoadJson(String path)
  {
    JSONObject json = loadJSONObject(path);
    
    NbLines = json.getInt("NbLines", NbLines);
    Height = json.getFloat("Height", Height);
    XSteps = json.getInt("XSteps", XSteps);
    
    pos = new PVector(
      json.getFloat("pos_x", pos.x),
      json.getFloat("pos_y", pos.y)
    );
    
    seed = json.getInt("seed", seed);
    

    intersection = json.getBoolean("intersection", intersection);
    moveSpeed = json.getFloat("moveSpeed", moveSpeed);

    Noise1.LoadJson(json.getJSONObject("Noise1"));
    Noise2.LoadJson(json.getJSONObject("Noise2"));
  }

  void SaveJson(String path)
  {
    JSONObject json = new JSONObject();

    json.setJSONObject("Noise1", Noise1.SaveJson());
    json.setJSONObject("Noise2", Noise2.SaveJson());

    json.setInt("NbLines", NbLines);
    json.setFloat("Height", Height);
    json.setInt("XSteps", XSteps);
    
    
    json.setFloat("pos_x", pos.x);
    json.setFloat("pos_y", pos.y);
    
    json.setInt("seed", seed);

    json.setBoolean("intersection", intersection);

    json.setFloat("moveSpeed", moveSpeed);
    saveJSONObject(json, path);
  }
}
