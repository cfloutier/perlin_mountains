


static float computePow(int mul)
{
  return pow(10, mul);
}

class LayerData
{
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
    
    float noise_X = data.main.pos.x - pow_X/2;
    float delta_noiseX =  pow_X / (data.main.XSteps-1);
   
    float ypos_Noise = data.main.pos.y + y * pow_Y;
   
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
    

    dest.setBoolean("add", add);
    dest.setBoolean("on", on);

    return dest;
  }
}

class LayerGui extends UI_Panel
{
  LayerGui(LayerData layerdata, String name)
  {
    this.layerdata = layerdata;
    this.name = name;
  }

  LayerData layerdata;

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
    xNoise.setValue(layerdata.xNoise);
    yNoise.setValue(layerdata.yNoise);
    
    Height_Noise.setValue(layerdata.Height_Noise);
    Added_Height.setValue(layerdata.Added_Height);

    xNoise_Mul.setValue(layerdata.xNoise_Mul);
    yNoise_Mul.setValue(layerdata.yNoise_Mul);
    Height_Mul.setValue(layerdata.Height_Mul);
    
    mode.setValue(layerdata.mode);
    
    add.setValue(layerdata.add);
    on.setValue(layerdata.on);

    update();
  }

  void setupControls(String name, ControlP5 cp5)
  {
    super.Init(name, cp5);

    addLabel(name);
    
    on = addToggle("on", "on/off", layerdata);

    xNoise = addSlider("xNoise", "X Noise", layerdata, 0, 10, true);
    yNoise = addSlider("yNoise", "Y Noise", layerdata, 0, 30, true);
    Height_Noise = addSlider("Height_Noise", "Height_Noise", layerdata, 0, 10, false);
    
    xNoise_Mul = addIntSlider("xNoise_Mul", "X Noise Mult.", layerdata, -1, 2, true);
    yNoise_Mul = addIntSlider("yNoise_Mul", "Y Noise Mult.", layerdata, -1, 3, true);
    Height_Mul = addIntSlider("Height_Mul", "Height Mult", layerdata, -3, 1, false);
    
    Added_Height = addSlider("Added_Height", "Added_Height", layerdata, -1, 1, false);
    
    Reset_Added_Height = addButton("recenter");
    Reset_Added_Height.plugTo(this,"rescenterH");
    
    add = addToggle("add", "add values", layerdata);
    
    mode = addIntSlider("mode", "mode", layerdata, 0, 2, false);
  }

  void rescenterH()
  {
    layerdata.Added_Height = 0;
    setGUIValues();
  }

  void update()
  {
    xNoise_Mul.setValueLabel("x " + computePow(layerdata.xNoise_Mul));
    yNoise_Mul.setValueLabel("x " + computePow(layerdata.yNoise_Mul));
    Height_Mul.setValueLabel("x " + computePow(layerdata.Height_Mul));

    if (layerdata.add)
      add.setLabel("Add Values");
    else
      add.setLabel("Max Value");
    
    
    switch(layerdata.mode)
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
