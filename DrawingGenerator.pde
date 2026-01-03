class Line
{
  ArrayList<PVector> points = new ArrayList<PVector>();
  boolean[] validity = null;
  
  float y_line = 0;

  void build(float yNoise, float yLine)
  {
    points = null;

    this.y_line = yLine;

    float xPos = 0;
    float deltaX = data.width / (data.main.XSteps - 1);
    points = new ArrayList<PVector>();
    setAllValid();

    for (int i = 0; i < data.main.XSteps; i++)
    {
      points.add(new PVector(xPos, 0));
      xPos += deltaX;
    }
    
    DataLayers layers = data.layers; 
    for (int i = 0; i < layers.count(); i++)
    {
      DataLayer layer = layers.layer(i);
      layer.compute_Line(points, yNoise);
    }
  }

  void draw()
  {
    current_graphics.noFill();

    current_graphics.beginShape();
    boolean drawing = false;

    for (int i = 0; i < points.size(); i++)
    {
      boolean valid = validity[i];
      if (valid)
      {
        PVector pA = points.get(i);
        if (!drawing)
        {
          drawing = true;
          current_graphics.beginShape();     
        }
        
        current_graphics.vertex(pA.x, pA.y + y_line);
      }
      else{
        if (drawing)
        {
          drawing = false;
          current_graphics.endShape();     
        }
      }
    }

    if (drawing)
    {
      drawing = false;
      current_graphics.endShape();     
    }
  }

  void setAllValid()
  {
    validity = new boolean[data.main.XSteps];
    for (int i = 0; i < data.main.XSteps; i++)
      validity[i] = true;
  }

  void mergeWith(Line prevLine, int[] counters)
  {
    for (int i = 0; i < data.main.XSteps; i++)
    {
      float y = points.get(i).y + y_line;
      float prev_y =  prevLine.points.get(i).y + prevLine.y_line;

      if (y > prev_y)
      {
        int counter = counters[i] + 1; 
        counters[i] = counter;
        
        points.get(i).y = prev_y - y_line;

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

class DrawingGenerator
{
  ArrayList<Line> lines;

  int lastUpdate  = 0;

  void update()
  {
    noiseSeed(data.main.seed);
    noiseDetail(data.main.NoiseLod, data.main.NoiseFalloff);
    
    my_noiseSeed(data.main.seed);
    my_noiseDetail(data.main.NoiseLod, data.main.NoiseFalloff);

    lines = new ArrayList<Line>();
    

    float y_Noise = data.main.Height /2;
    float y_Line = data.height/2 + y_Noise * data.width;

    float delta_y_Noise = 1;
    float delta_y = 1;
    if (data.main.NbLines != 0)
    {
      delta_y_Noise = -data.main.Height / (data.main.NbLines - 1);
      delta_y = delta_y_Noise * data.width;
    }

    if (data.main.NbLines == 1)
    {
      y_Line = data.height/2;
      y_Noise = 0;
    }

    Line prevLine = null;

    int[] counters = new int[data.main.XSteps];
    if (data.main.intersection)
    {  
       for (int i = 0; i < data.main.XSteps; i++)
        counters[i] = 0;
    }

    for (int lineIndex = 0; lineIndex < data.main.NbLines; lineIndex++)
    {
      Line line = new Line();
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
      drawer.update();
      data.reset_all_changes();
    }
    
    for (int lineIndex = 0; lineIndex < lines.size(); lineIndex++)
    {
      lines.get(lineIndex).draw();  
    }
    
    
  }
}
