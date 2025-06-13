


static float computePow(int mul)
{
  return pow(10, mul);
}

class DataLayer extends GenericData
{
  
    DataLayer(String layer_name)
    {
      super(layer_name);
      
    }
  
  
  boolean on = false;

  int mode = 0;

  float xNoise = 0.4;
  float yNoise = 0.4;
  float Height_Noise = 5;

  float Added_Height = 0;

  int xNoise_Mul = 1;
  int yNoise_Mul = 1;
  int Height_Mul = 1;

  boolean add = true;

  float pow_X;
  float pow_Y;
  float pow_H;

  PVector pos = new PVector(0, 0);

  void computePowS()
  {
    pow_X = computePow(xNoise_Mul)*xNoise;
    pow_Y = computePow(yNoise_Mul)*yNoise;
    pow_H = computePow(Height_Mul)*Height_Noise;
  }


  float computeNoise(float noise_X, float noise_Y)
  {
    switch(mode)
    {
    default:
    case 0:
      return noise(noise_X, noise_Y) - 0.5;
    case 1:
      return my_noise(noise_X, noise_Y) - 0.5;
    case 2:
      return sin(noise_X+noise_Y) *0.5f;
    }
  }

  ArrayList<PVector> compute_Line(ArrayList<PVector> points, float y)
  {
    if (!on)
      return points;

    float noise_X = pos.x - pow_X/2;
    float delta_noiseX =  pow_X / (data.main.XSteps-1);

    float ypos_Noise = pos.y + y * pow_Y;

    for (int i = 0; i < data.main.XSteps; i++)
    {  
      // float noise = noise_d(noise_X, ypos_Noise) - 0.5;
      //float noise = noise(noise_X, ypos_Noise) - 0.5;

      // noise = sin(noise_X + ypos_Noise)/2;
      float noise = computeNoise(noise_X, ypos_Noise);

      float h = (pow_H * noise - Added_Height) * data.width;     
      PVector prevPoint = points.get(i);
      PVector newPoint = null;
      if (add)
        newPoint = new PVector(prevPoint.x, h + prevPoint.y);   
      else
      {
        float min = min(prevPoint.y, h);
        newPoint = new PVector(prevPoint.x, min);
      }

      points.set(i, newPoint); 
      noise_X += delta_noiseX;
    }

    return points;
  }

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    xNoise = src.getFloat("xNoise", xNoise);
    yNoise = src.getFloat("yNoise", yNoise);
    Height_Noise = src.getFloat("Height_Noise", Height_Noise);
    Added_Height = src.getFloat("Added_Height", Added_Height);

    pos = new PVector(
      src.getFloat("pos_x", pos.x), 
      src.getFloat("pos_y", pos.y));

    xNoise_Mul = src.getInt("xNoise_Mul", xNoise_Mul);
    yNoise_Mul = src.getInt("yNoise_Mul", yNoise_Mul);
    Height_Mul = src.getInt("Height_Mul", Height_Mul);

    mode = src.getInt("mode", mode);

    add = src.getBoolean("add", add);
    on = src.getBoolean("on", add);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setFloat("xNoise", xNoise);
    dest.setFloat("yNoise", yNoise);
    dest.setFloat("Height_Noise", Height_Noise);
    dest.setFloat("Added_Height", Added_Height);


    dest.setInt("xNoise_Mul", xNoise_Mul);
    dest.setInt("yNoise_Mul", yNoise_Mul);
    dest.setInt("Height_Mul", Height_Mul);

    dest.setInt("mode", mode);

    dest.setFloat("pos_x", pos.x);
    dest.setFloat("pos_y", pos.y);

    dest.setBoolean("add", add);
    dest.setBoolean("on", on);

    return dest;
  }
}

class LayerGui extends GUIPanel
{
  LayerGui(DataLayer data_layer, String name)
  {
    super(name, data_layer);
    this.data_layer = data_layer;
    this.name = name;
  }

  DataLayer data_layer;

  Slider xNoise;
  Slider Height_Noise;  
  Slider Added_Height;
  Button Reset_Added_Height;
  Slider yNoise;

  Slider xNoise_Mul;
  Slider yNoise_Mul;
  Slider Height_Mul;


  Slider mode;
  Toggle add;
  Toggle on;

  String name;

  void setGUIValues()
  {
    xNoise.setValue(data_layer.xNoise);
    yNoise.setValue(data_layer.yNoise);

    Height_Noise.setValue(data_layer.Height_Noise);
    Added_Height.setValue(data_layer.Added_Height);

    xNoise_Mul.setValue(data_layer.xNoise_Mul);
    yNoise_Mul.setValue(data_layer.yNoise_Mul);
    Height_Mul.setValue(data_layer.Height_Mul);

    mode.setValue(data_layer.mode);

    add.setValue(data_layer.add);
    on.setValue(data_layer.on);

    update_ui();
  }

  void setupControls(String name)
  {
    super.Init();

    addLabel(name);

    on = addToggle("on", "on/off");

    xNoise = addSlider("xNoise", "X Noise", 0, 10);
    yNoise = addSlider("yNoise", "Y Noise", 0, 30);
    Height_Noise = addSlider("Height_Noise", "Height_Noise", 0, 10);

    xNoise_Mul = addIntSlider("xNoise_Mul", "X Noise Mult.", -1, 2);
    yNoise_Mul = addIntSlider("yNoise_Mul", "Y Noise Mult.", -1, 3);
    Height_Mul = addIntSlider("Height_Mul", "Height Mult", -3, 1);

    Added_Height = addSlider("Added_Height", "Added_Height", -1, 1);

    Reset_Added_Height = addButton("recenter");
    Reset_Added_Height.plugTo(this, "rescenterH");

    add = addToggle("add", "add values");

    mode = addIntSlider("mode", "mode", 0, 2);
  }

  void rescenterH()
  {
    data_layer.Added_Height = 0;
    setGUIValues();
  }

  void update_ui()
  {
    xNoise_Mul.setValueLabel("x " + computePow(data_layer.xNoise_Mul));
    yNoise_Mul.setValueLabel("x " + computePow(data_layer.yNoise_Mul));
    Height_Mul.setValueLabel("x " + computePow(data_layer.Height_Mul));

    if (data_layer.add)
      add.setLabel("Add Values");
    else
      add.setLabel("Max Value");


    switch(data_layer.mode)
    {
    default:
    case 0:
      mode.setValueLabel("Standard perlin Noise");
      break;
    case 1:
      mode.setValueLabel("My perlin Noise"); 
      break;
    case 2:
      mode.setValueLabel("Sinus");
      break;
    }
  }
}
