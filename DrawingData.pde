 //<>//
class DrawingData
{
  boolean changed = true;

  PVector pos = new PVector(0, 0);

  int NbLines = 100;

  int XSteps = 300;
  float Height = 0.5;


  float xNoise1 = 0.2;
  float xNoise2 = 0;

  
  float yNoise1 = 1;
  float yNoise2 = 3;

  
  float HeightLine1 = 900;
  float HeightLine2 = 0;


  boolean intersection = true;
  
  float moveSpeed = 1;
  PVector move = new PVector(0, 0);

  void LoadJson(String path)
  {
    JSONObject json = loadJSONObject(path);
    NbLines = json.getInt("NbLines", NbLines);
    Height = json.getFloat("Height", Height);
    XSteps = json.getInt("XSteps", XSteps);
    
    xNoise1 = json.getFloat("xNoise1", xNoise1);
    xNoise2 = json.getFloat("xNoise2", xNoise2);

    yNoise1 = json.getFloat("yNoise1", yNoise1);
    yNoise2 = json.getFloat("yNoise2", yNoise2);
   
    HeightLine1 = json.getFloat("HeightLine1", HeightLine1);
    HeightLine2 = json.getFloat("HeightLine2", HeightLine2);
  
    intersection = json.getBoolean("intersection", intersection);
    moveSpeed = json.getFloat("yNoise", moveSpeed);
  }

  void SaveJson(String path)
  {
    JSONObject json = new JSONObject();

    json.setInt("NbLines", NbLines);
    json.setFloat("Height", Height);
    json.setInt("XSteps", XSteps);
    json.setFloat("xNoise1", xNoise1);
    json.setFloat("xNoise2", xNoise2);

    json.setFloat("yNoise1", yNoise1);
    json.setFloat("yNoise2", yNoise2);
    
    json.setFloat("HeightLine1", HeightLine1);
    json.setFloat("HeightLine2", HeightLine2);
   
    
    json.setBoolean("intersection", intersection);

     json.setFloat("moveSpeed", moveSpeed);
    saveJSONObject(json, path);
  }
}
