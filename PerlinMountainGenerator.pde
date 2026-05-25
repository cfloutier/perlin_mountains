class PerlinLine extends ValidatedPolylineWithOffset
{
  void build(float yPeriod, float yLine)
  {
    clear();
    setYOffset(yLine);

    float xPos = 0;
    float deltaX = (float)data.main.Width / (data.main.XSteps - 1);
    setAllValid();

    for (int i = 0; i < data.main.XSteps; i++)
    {
      addPoint(new PVector(xPos, 0));
      xPos += deltaX;
    }
    
    DataLayers layers = data.layers; 
    for (int i = 0; i < layers.count(); i++)
    {
      DataLayer layer = layers.layer(i);
      layer.compute_Line(points, yPeriod);
    }
  }

  void setAllValid()
  {
    boolean[] valid = new boolean[data.main.XSteps];
    for (int i = 0; i < data.main.XSteps; i++)
      valid[i] = true;
    setValidity(valid);
  }

  void mergeWith(PerlinLine prevLine, int[] counters)
  {
    for (int i = 0; i < data.main.XSteps; i++)
    {
      float y = points.get(i).y + y_offset;
      float prev_y = prevLine.points.get(i).y + prevLine.y_offset;

      if (y > prev_y)
      {
        int counter = counters[i] + 1; 
        counters[i] = counter;
        
        points.get(i).y = prev_y - y_offset;

        if (counter > data.main.max_override)
          validity[i] = false;
        else
          validity[i] = true;
      }
      else
      {
        counters[i] = 0;
        validity[i] = true;
      }
    }
  }
}

class PerlinMountainGenerator
{
  ArrayList<PerlinLine> lines;

  int lastUpdate  = 0;

  void update()
  {
    noiseSeed(data.main.seed);
    noiseDetail(data.main.NoiseLod, data.main.NoiseFalloff);
    
    for (int layer_index = 0; layer_index < data.layers.count(); layer_index++)
      data.layers.layer(layer_index).InitNoise(data.main.seed);

    lines = new ArrayList<PerlinLine>();

    float y_Noise = data.main.HeightRatio /2;
    float y_Line = y_Noise * data.main.Width;

    float delta_y_Noise = 1;
    float delta_y = 1;
    if (data.main.NbLines != 0)
    {
      delta_y_Noise = -data.main.HeightRatio / (data.main.NbLines - 1);
      delta_y = delta_y_Noise * data.main.Width;
    }

    if (data.main.NbLines == 1)
    {
      y_Line = 0;
      y_Noise = 0;
    }

    PerlinLine prevLine = null;

    int[] counters = new int[data.main.XSteps];
    if (data.main.intersection)
    {  
       for (int i = 0; i < data.main.XSteps; i++)
        counters[i] = 0;
    }

    for (int lineIndex = 0; lineIndex < data.main.NbLines; lineIndex++)
    {
      PerlinLine line = new PerlinLine();
      line.build(y_Noise, y_Line);

      if (data.main.intersection)
      {
        if (prevLine != null)
          line.mergeWith(prevLine, counters);
      }

      prevLine = line;

      lines.add(line);
      y_Noise += delta_y_Noise;
      y_Line += delta_y;
    }
  }
  
  void draw()
  {
    //print("draw");
    boolean needUpdate = false;
   
    if (data.any_change())  
    {
      needUpdate = true;
    }
    
    if (dataGui.checkKeyMove())
      needUpdate = true;
      
    if (needUpdate)
    {
      update();
      data.reset_all_changes();
    }
    
    for (int lineIndex = 0; lineIndex < lines.size(); lineIndex++)
    {
      lines.get(lineIndex).draw();  
    }
  }

  BoundingBox getBoundingBox()
  {
    BoundingBox bbox = new BoundingBox();
    for (PerlinLine line : lines)
    {
      for (int i = 0; i < line.size(); i++)
      {
        if (line.validity == null || line.validity[i])
        {
          PVector p = line.get(i);
          bbox.addPoint(new PVector(p.x, p.y + line.y_offset));
        }
      }
    }
    return bbox;
  }
}
