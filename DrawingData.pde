 //<>// //<>//
class DrawingData
{
  Style style = new Style();

  String name = "";

  boolean changed = true;

  MainData main = new MainData();
  LayerData Noise1 = new LayerData();
  LayerData Noise2 = new LayerData();

  void LoadJson(String path)
  {
    JSONObject json = loadJSONObject(path);

    style.LoadJson(json.getJSONObject("Style"));
    main.LoadJson(json.getJSONObject("Main"));

    Noise1.LoadJson(json.getJSONObject("Noise1"));
    Noise2.LoadJson(json.getJSONObject("Noise2"));
    style.LoadJson(json.getJSONObject("Style"));
  }

  void SaveJson(String path)
  {
    JSONObject json = new JSONObject();

    json.setJSONObject("Noise1", Noise1.SaveJson());
    json.setJSONObject("Noise2", Noise2.SaveJson());
    json.setJSONObject("Style", style.SaveJson());
    json.setJSONObject("Main", main.SaveJson());

    saveJSONObject(json, path);
  }
}

class MainData
{
  int NbLines = 100;

  int XSteps = 300;
  float Height = 0.5;

  int seed; 
  boolean intersection = true;

  PVector pos = new PVector(0, 0);

  float moveSpeed = 1;
  PVector move = new PVector(0, 0);

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    NbLines = src.getInt("NbLines", NbLines);
    Height = src.getFloat("Height", Height);
    XSteps = src.getInt("XSteps", XSteps);

    pos = new PVector(
      src.getFloat("pos_x", pos.x), 
      src.getFloat("pos_y", pos.y)
      );

    seed = src.getInt("seed", seed);


    intersection = src.getBoolean("intersection", intersection);
    moveSpeed = src.getFloat("moveSpeed", moveSpeed);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();

    dest.setInt("NbLines", NbLines);
    dest.setFloat("Height", Height);
    dest.setInt("XSteps", XSteps);

    dest.setFloat("pos_x", pos.x);
    dest.setFloat("pos_y", pos.y);

    dest.setInt("seed", seed);

    dest.setBoolean("intersection", intersection);

    dest.setFloat("moveSpeed", moveSpeed);


    return dest;
  }
}


class Style
{
  color backgroundColor = color(0, 0, 0);
  color lineColor = color(255, 255, 255);
  float lineWidth = 1;

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    backgroundColor = src.getInt("backgroundColor", backgroundColor);
    lineColor = src.getInt("lineColor", lineColor);
    lineWidth = src.getFloat("lineWidth", lineWidth);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setInt("backgroundColor", backgroundColor);
    dest.setInt("lineColor", lineColor);
    dest.setFloat("lineWidth", lineWidth);

    return dest;
  }
}
