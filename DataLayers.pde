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

  int line_mode = 0;

  float xNoise = 0.4;
  float yNoise = 0.4;
  float Height_Noise = 5;

  float Added_Height = 0;

  int xNoise_Mul = 1;
  int yNoise_Mul = 1;
  int Height_Mul = 1;

  boolean add = true;

  float pos_x = 0;
  float pos_y = 0;
  
  PVector start_mouse_drag = new PVector(0,0);
  PVector previous_pos = new PVector(0,0);
  
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
      return sin(noise_X+noise_Y) *0.5f;
    }
  }
  
  float pow_X()
  {
    return computePow(xNoise_Mul)*xNoise;
  }
  
  float pow_Y()
  {
    return computePow(yNoise_Mul)*yNoise;
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

  RadioButton line_mode;

  Slider xNoise;
  Slider Height_Noise;  
  Slider Added_Height;  
  Button Reset_Added_Height;
  Slider yNoise;

  Slider xNoise_Mul;
  Slider yNoise_Mul;
  Slider Height_Mul;

  Toggle add;
  Toggle on;

  void setupControls()
  {
    super.Init();

    addListBar();

    float start_yPos = yPos;

    current_Layer = addLabel("current Layer : ??");

    on = addToggle("on", "on/off", pdata.edit_layer);

    ArrayList<String> labels = new ArrayList<String>();
    labels.add("Perlin Noise");
    labels.add("Sinus");  

    yPos = start_yPos;
    
    addLabel("Line Mode");
    
    line_mode = addRadio("line_mode", labels, pdata.edit_layer);  

    space();

    nextLine();

    xNoise = addSlider("xNoise", "X Noise", pdata.edit_layer, 0, 10);
    yNoise = addSlider("yNoise", "Y Noise", pdata.edit_layer, 0, 30);
    Height_Noise = addSlider("Height_Noise", "Height_Noise", pdata.edit_layer,  0, 10);

    nextLine();

    xNoise_Mul = addIntSlider("xNoise_Mul", "X Noise Mult.", pdata.edit_layer, -1, 2);
    yNoise_Mul = addIntSlider("yNoise_Mul", "Y Noise Mult.", pdata.edit_layer, -1, 3);
    Height_Mul = addIntSlider("Height_Mul", "Height Mult", pdata.edit_layer, -3, 1);

    nextLine();

    Added_Height = addSlider("Added_Height", "Added_Height", pdata.edit_layer, -1, 1);
    Reset_Added_Height = addButton("recenter");
    Reset_Added_Height.plugTo(this, "rescenterH");
    
    nextLine();

    add = addToggle("add", "add values", pdata.edit_layer);

  }

  void updateCurrentItem()
  {
    if (pdata.count() == 0)
    {
      on.hide();
      line_mode.hide();
      xNoise.hide();
      yNoise.hide();
      Height_Noise.hide();
      xNoise_Mul.hide();
      yNoise_Mul.hide();
      Height_Mul.hide();
      Added_Height.hide();
      Reset_Added_Height.hide();
      add.hide();

      current_Layer.setText("No Planet");

      return;
    }

    on.show();
    line_mode.show();
    xNoise.show();
    yNoise.show();
    Height_Noise.show();
    xNoise_Mul.show();
    yNoise_Mul.show();
    Height_Mul.show();
    Added_Height.show();
    Reset_Added_Height.show();
    add.show();

    if (pdata.current_index != last_index)
    {
      last_index = pdata.current_index;
      
      DataLayer layer = pdata.layer(pdata.current_index);
      pdata.edit_layer.CopyFrom(layer);
      
      on.setValue(layer.on);
      line_mode.activate(layer.line_mode);

      xNoise.setValue(layer.xNoise);
      yNoise.setValue(layer.yNoise);
      Height_Noise.setValue(layer.Height_Noise);

      xNoise_Mul.setValue(layer.xNoise_Mul);
      yNoise_Mul.setValue(layer.yNoise_Mul);
      Height_Mul.setValue(layer.Height_Mul);

      Added_Height.setValue(layer.Added_Height);

      add.setValue(layer.add);
      
      current_Layer.setText("Layer " + (pdata.current_index + 1) + " / " + pdata.count());
    }
    else
    {
      DataLayer layer = pdata.layer(pdata.current_index);
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
    pdata.edit_layer.Added_Height = 0;
    setGUIValues();
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
