static float computePow(int mul)
{
  return pow(10, mul);
}

class DataLayer extends GenericData
{
  DataLayer() {
    super("Layer");
  }
  
  boolean on = false;

  // 0 : global noise
  // 1 : local noise
  // 3 : sinus 
  // 4 : gaussian
  int line_mode = 0;

  // 0 : max of previous value
  // 1 : add to previous value
  // 2 : multiply previous value
  int layer_mode = 1;

  float xPeriod = 0.4;
  float yPeriod = 0.4;
  float Height_Noise = 5;

  float Base_Height = 0;

  int xPeriod_Mul = 1;
  int yPeriod_Mul = 1;
  int Height_Mul = 1;

  float pos_x = 0;
  float pos_y = 0;

  int NoiseLod = 4;
  float NoiseFalloff = 0.5;

  PerlinNoise local_noise = new PerlinNoise();
  
  PVector start_mouse_drag = new PVector(0,0);
  PVector previous_pos = new PVector(0,0);

  public void InitNoise(int seed)
  {
    local_noise.noiseSeed(seed);
    local_noise.noiseDetail(NoiseLod, NoiseFalloff);
  }
  
  void on_start_drag()
  {
    start_mouse_drag = new PVector(mouseX,mouseY);
    previous_pos = new PVector(pos_x, pos_y);
  }

  void on_drag()
  {
    PVector delta_mouse = new PVector(mouseX - start_mouse_drag.x,mouseY -start_mouse_drag.y);

    float move_x = -0.001*delta_mouse.x * data.main.moveSpeed_X;
    float move_y = -0.001*delta_mouse.y * data.main.moveSpeed_Y;
   
    pos_x = previous_pos.x + move_x * pow_X();
    pos_y = previous_pos.y + move_y * pow_Y(); 
  }

  float computeNoise(float noise_X, float noise_Y)
  {

    //return sin(noise_X+noise_Y) *0.5f
    // line_mode = 1;
    
    switch(line_mode)
    {
    default:
    case 0:
      return noise(noise_X, noise_Y) - 0.5;
    case 1:
      return local_noise.noise(noise_X, noise_Y) - 0.5;  
    case 2:
      return sin(noise_X+noise_Y) * 0.5f;
    case 3:
      return -exp(- (noise_X*noise_X) ) ;
    
    }
  }
  
  float pow_X()
  {
    return computePow(xPeriod_Mul)*xPeriod;
  }
  
  float pow_Y()
  {
    return computePow(yPeriod_Mul)*yPeriod;
  }

  ArrayList<PVector> compute_Line(ArrayList<PVector> points, float y)
  {
    if (!on)
      return points;
   
    float pow_X = pow_X();
    float pow_Y = pow_Y();
    float pow_H = computePow(Height_Mul)*Height_Noise;
 
    float noise_X = pos_x - pow_X/2;
    float delta_noiseX =  pow_X / (data.main.XSteps-1);

    float ypos_Noise = pos_y + y * pow_Y;

    for (int i = 0; i < data.main.XSteps; i++)
    {  
      float noise = computeNoise(noise_X, ypos_Noise);

      float h = (pow_H * noise - Base_Height) * data.width;     
      PVector prevPoint = points.get(i);
      PVector newPoint = null;

      switch(layer_mode)
      {
        case 0: // min
          float min = min(prevPoint.y, h);
          newPoint = new PVector(prevPoint.x, min);
          break;
        default:
        case 1: // add
          newPoint = new PVector(prevPoint.x, h + prevPoint.y);   
          break;
        case 2: // mul
          float mul = prevPoint.y * h;
          newPoint = new PVector(prevPoint.x, mul);   
          break;
      }

      points.set(i, newPoint); 
      noise_X += delta_noiseX;
    }

    return points;
  }
}

class DataLayers extends DataList
{
  DataLayer edit_layer = new DataLayer();

  DataLayers() {
    super("Layers", "layer");
  }
  
  void apply_to_edit()
  {
    if (count() == 0)
      return;

   if (current_index < 0 || current_index >= count())
      current_index = 0;

    edit_layer.CopyFrom(layer(current_index));
  }

  void reset()
  {
    super.reset();
    edit_layer.CopyFrom(new DataLayer());
  }
  
  DataLayer newItem()
  {
    return new DataLayer();
  }
  
  DataLayer layer(int index)
  {
    return (DataLayer) items.get(index);
  }
}

class LayersGui extends GUIListPanel
{
  DataLayers pdata = null;
  
  LayersGui(DataLayers data)
  {
    super("Layers", data);
    this.pdata = data;
  }

  Textlabel current_Layer;

  Toggle on;

  Button resetPos_X;
  Button resetPos_Y;

  myRadioButton line_mode;
  myRadioButton layer_mode;
  
  Slider xPeriod;
  Slider yPeriod;

  Slider xPeriod_Mul;
  Slider yPeriod_Mul;

  Textlabel Height_Label;
  Slider Height_Noise;  
  Slider Height_Mul;

  Slider Base_Height;  
  Button Reset_Base_Height;
  
  Textlabel Noise_Label;
  Slider NoiseLod;
  Slider NoiseFalloff;

  void setupControls()
  {
    super.Init();

    addListBar();

    float start_yPos = yPos;

    current_Layer = addLabel("current Layer : ??");

    on = addToggle("on", "on/off", pdata.edit_layer);

    ArrayList<String> labels_line_mode = new ArrayList<String>();
    labels_line_mode.add("Global Noise");
    labels_line_mode.add("Local Noise");  
    labels_line_mode.add("Sinus");    
    labels_line_mode.add("Gaussian");    

    yPos = start_yPos;

    
    addLabel("Line Mode");
    line_mode = addRadio("line_mode", labels_line_mode, pdata.edit_layer);  
    space();

    ArrayList<String> labels_layer_mode = new ArrayList<String>();
    labels_layer_mode.add("Max");
    labels_layer_mode.add("Add");  
    labels_layer_mode.add("Multiply");

    addLabel("Layer Mode");
    layer_mode = addRadio("layer_mode", labels_layer_mode, pdata.edit_layer);  
    space();

    resetPos_X = addButton("reset pos X");
    resetPos_X.plugTo(this, "resetPosX");

    resetPos_Y = addButton("reset pos Y");
    resetPos_Y.plugTo(this, "resetPosY");

    nextLine();

    space();
    
    xPeriod = addSlider("xPeriod", "X Period", pdata.edit_layer, 0, 10);
    xPeriod_Mul = addIntSlider("xPeriod_Mul", "X Period Mult.", pdata.edit_layer, -1, 2);
    
    nextLine();
    yPeriod = addSlider("yPeriod", "Y Period", pdata.edit_layer, 0, 30);
    yPeriod_Mul = addIntSlider("yPeriod_Mul", "Y Period Mult.", pdata.edit_layer, -1, 3);

    nextLine();

    Height_Label = addLabel("Height : ");
    Height_Noise = addSlider("Height_Noise", "Height Noise", pdata.edit_layer,  0, 10);
    Height_Mul = addIntSlider("Height_Mul", "Height Mult", pdata.edit_layer, -3, 1);

    nextLine();
    Base_Height = addSlider("Base_Height", "Base Height", pdata.edit_layer, -1, 1);
    Reset_Base_Height = addButton("recenter");
    Reset_Base_Height.plugTo(this, "rescenterH");
    
    nextLine();
    
    Noise_Label = addLabel("Noise : ");
    NoiseLod = addIntSlider("NoiseLod", "Noise Harmonics", pdata.edit_layer, 1, 8);
    NoiseFalloff = addSlider("NoiseFalloff", "NoiseFalloff", pdata.edit_layer, 0, 1);
  }

  void updateCurrentItem()
  {
    if (pdata.count() == 0)
    {
      on.hide();
      line_mode.hide();
      xPeriod.hide();
      yPeriod.hide();
      Height_Noise.hide();
      xPeriod_Mul.hide();
      yPeriod_Mul.hide();
      Height_Mul.hide();
      Base_Height.hide();
      Reset_Base_Height.hide();
      line_mode.hide();
      Noise_Label.hide();
      NoiseLod.hide();
      NoiseFalloff.hide();

      current_Layer.setText("No Planet");

      return;
    }
    
    DataLayer layer = pdata.layer(pdata.current_index);

    on.show();
    line_mode.show();
    xPeriod.show();
    yPeriod.show();
    Height_Noise.show();
    xPeriod_Mul.show();
    yPeriod_Mul.show();
    Height_Mul.show();
    Base_Height.show();
    Reset_Base_Height.show();
    line_mode.show();
    NoiseLod.show();
    NoiseFalloff.show();  
    if (layer.line_mode == 1)
    {
      NoiseLod.show();
      NoiseFalloff.show();  
    }
    else
    {
       NoiseLod.hide();
       NoiseFalloff.hide();   
    }

    if (pdata.current_index != last_index)
    {
      last_index = pdata.current_index;
      pdata.edit_layer.CopyFrom(layer);
      
      on.setValue(layer.on);
      line_mode.setValue(layer.line_mode);
      layer_mode.setValue(layer.layer_mode);      

      xPeriod.setValue(layer.xPeriod);
      yPeriod.setValue(layer.yPeriod);
      Height_Noise.setValue(layer.Height_Noise);

      xPeriod_Mul.setValue(layer.xPeriod_Mul);
      yPeriod_Mul.setValue(layer.yPeriod_Mul);
      Height_Mul.setValue(layer.Height_Mul);

      Base_Height.setValue(layer.Base_Height);

      NoiseLod.setValue(layer.NoiseLod);
      NoiseFalloff.setValue(layer.NoiseFalloff);
      
      current_Layer.setText("Layer " + (pdata.current_index + 1) + " / " + pdata.count());
    }
    else
    {
      layer.CopyFrom(pdata.edit_layer);
      data.changed = true;
    }
  }

  void update_ui()
  {
    updateCurrentItem();
  }

  void setGUIValues()
  {
    // super important car sinon les champs dans edit_layers sont maintenus
    last_index = -1;
    updateCurrentItem();
  }
  
  void rescenterH()
  {
    //print("recenter");
    DataLayer layer = pdata.layer(pdata.current_index);
    layer.Base_Height = 0;
    Base_Height.setValue(layer.Base_Height);
  }

  void resetPosX()
  {
    //print("resetPosX");
    DataLayer layer = pdata.layer(pdata.current_index);
    layer.pos_x = 0;
    pdata.edit_layer.pos_x = layer.pos_x;
    
  }

  void resetPosY()
  {
    //print("resetPosY");
    DataLayer layer = pdata.layer(pdata.current_index);
    layer.pos_y = 0;
    pdata.edit_layer.pos_y = layer.pos_y;
  }

  void draw()
  {
    
  }

  boolean key_move(PVector key_move, int delta_ms)
  {
    if (pdata.count() == 0)
      return false;

    if (pdata.current_index < 0 || pdata.current_index >= pdata.count())
      return false;

    DataLayer layer = pdata.layer(pdata.current_index);

    float move_x =  0.001*key_move.x * delta_ms * data.main.moveSpeed_X;
    float move_y =  0.001*key_move.y * delta_ms * data.main.moveSpeed_Y;

    layer.pos_x += move_x * layer.pow_X();
    layer.pos_y += move_y * layer.pow_Y(); 
    
    pdata.edit_layer.pos_x = layer.pos_x;
    pdata.edit_layer.pos_y = layer.pos_y;

    return true;
  }
  
  
  boolean drag_current = true;
  boolean dragging = false;
  
  
  void on_start_drag()
  {
    dragging = true;
    drag_current = tab.isActive();
    
    if (drag_current)
    {
       DataLayer layer = pdata.layer(pdata.current_index);
       if (pdata.count() == 0)
        return;
  
      if (pdata.current_index < 0 || pdata.current_index >= pdata.count())
        return; 
        
      layer.on_start_drag();        
    }
    else
    {
        for (int i = 0 ; i < pdata.count(); i++)
        {
          DataLayer layer = pdata.layer(i);
          layer.on_start_drag();
        }
    }   
  }
  
  
  void on_drag()
  {
    if (!dragging) 
      return;
    
    if (drag_current)
    {
       DataLayer layer = pdata.layer(pdata.current_index);
       if (pdata.count() == 0)
        return;
  
      if (pdata.current_index < 0 || pdata.current_index >= pdata.count())
        return; 
        
      layer.on_drag();        
    }
    else
    {
        for (int i = 0 ; i < pdata.count(); i++)
        {
          DataLayer layer = pdata.layer(i);
          layer.on_drag();
        }
    }
    
    pdata.apply_to_edit();
    pdata.changed = true;
  }
  
  void end_drag()
  {
    dragging = false;
  }
}
