 
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




class StyleGUI extends UI_Panel
{
  Slider lineWidth;
  Style style;
  ColorPicker backgroundColor;
  ColorPicker lineColor;

  void setGUIValues()
  {
    lineWidth.setValue(style.lineWidth);
    backgroundColor.setColorValue(style.backgroundColor);
  }

  void setupControls(ControlP5 cp5)
  {
    style = data.style;
    super.Init("Style", cp5);
    lineWidth = addSlider("lineWidth", "Line Width", style, 0, 5, false);
    backgroundColor = addColor("backgroundColor", "background Color", style);  
    lineColor = addColor("lineColor", "line Color", style);
  }

  void update()
  {
    style.backgroundColor = backgroundColor.getColorValue();
    style.lineColor = lineColor.getColorValue();
  }
}
