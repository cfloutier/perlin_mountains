class LayerGui 
{
  LayerGui(LayerData layerdata)
  {
    this.layerdata = layerdata;
  }

  LayerData layerdata;

  Slider xNoise;
  Slider yNoise;
  Slider HeightLine;

  void setGUIValues()
  {
    xNoise.setValue(layerdata.xNoise);
    yNoise.setValue(layerdata.yNoise);
    HeightLine.setValue(layerdata.HeightLine);
  }

  void setupControls(UI_Panel panel)
  {
    panel.addLabel("Noise Layer 1");

    xNoise = panel.addSlider("xNoise", layerdata, 0, 10, true);
    yNoise = panel.addSlider("yNoise", layerdata, 0, 30, true);
    HeightLine = panel.addSlider("HeightLine", layerdata, 0, 2000, false);
    
    panel.yPos += 20;
  }
}
