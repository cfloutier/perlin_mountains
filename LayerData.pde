




class LayerData
{
  float xNoise = 0.4;
  float xNoise_Mul = 1;
  float yNoise = 0.4;
  float yNoise_Mul = 1;

  float HeightLine = 5;
  float Height_Mul = 1;

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;


    xNoise = src.getFloat("xNoise", xNoise);
    yNoise = src.getFloat("yNoise", yNoise);
    HeightLine = src.getFloat("HeightLine", HeightLine);
  }


  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setFloat("xNoise", xNoise);
    dest.setFloat("yNoise", yNoise);
    dest.setFloat("HeightLine", HeightLine);

    return dest;
  }
}
