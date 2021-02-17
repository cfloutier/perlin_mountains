class LayerGui 
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
  Slider yNoise;

  Slider xNoise_Mul;
  Slider yNoise_Mul;
  Slider Height_Mul;

  Toggle add;

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
    add.setValue(layerdata.add);

    update();
  }

  void setupControls(UI_Panel panel)
  {
    panel.yPos += 5;

    panel.addLabel(name);

    xNoise = panel.addSlider("xNoise", "X Noise", layerdata, 0, 10, true);
    yNoise = panel.addSlider("yNoise", "Y Noise", layerdata, 0, 30, true);
    Height_Noise = panel.addSlider("Height_Noise", "Height_Noise", layerdata, 0, 2000, false);
    
    xNoise_Mul = panel.addIntSlider("xNoise_Mul", "X Noise Mult.", layerdata, -3, 3, true);
    yNoise_Mul = panel.addIntSlider("yNoise_Mul", "Y Noise Mult.", layerdata, -3, 3, true);
    Height_Mul = panel.addIntSlider("Height_Mul", "Height Mult", layerdata, -3, 3, false);
    
    Added_Height = panel.addSlider("Added_Height", "Added_Height", layerdata, -1000, 1000, false);
    add = panel.addToggle("add", "add values", layerdata);


    panel.yPos += 5;
  }

  void update()
  {
    xNoise_Mul.setValueLabel("x " + pow(10.0, layerdata.xNoise_Mul));
    yNoise_Mul.setValueLabel("x " + pow(10.0, layerdata.yNoise_Mul));
    Height_Mul.setValueLabel("x " + pow(10.0, layerdata.Height_Mul));

    if (layerdata.add)
      add.setLabel("Add Values");
    else
      add.setLabel("Max Value");
    }
  }
