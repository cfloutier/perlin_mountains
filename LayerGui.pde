class LayerGui 
{
  LayerGui(LayerData layerdata, String name)
  {
    this.layerdata = layerdata;
    this.name = name;
  }

  LayerData layerdata;

  Slider xNoise;
  Slider yNoise;
  Slider HeightLine;

  String name;
  
  void setGUIValues()
  {
    xNoise.setValue(layerdata.xNoise);
    yNoise.setValue(layerdata.yNoise);
    HeightLine.setValue(layerdata.HeightLine);
  }

  void setupControls(UI_Panel panel)
  {
    panel.yPos += 5;
    
    panel.addLabel(name);

    xNoise = panel.addSlider("xNoise", "X Noise", layerdata, 0, 10, true);
    yNoise = panel.addSlider("yNoise", "Y Noise", layerdata, 0, 30, true);
    HeightLine = panel.addSlider("HeightLine", "Height Line", layerdata, 0, 2000, false);
    
    panel.yPos += 20;
  }
}
