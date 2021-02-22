//<>// //<>//

class Line
{
  ArrayList<PVector> points = new ArrayList<PVector>();

  float y_line = 0;

  void build(DrawingData data, float yNoise, float yLine)
  {

    points = null;

    this.y_line = yLine;

    float xPos = 0;
    float deltaX = data.width / (data.main.XSteps - 1);
    points = new ArrayList<PVector>();
    for (int i = 0; i < data.main.XSteps; i++)
    {
      points.add(new PVector(xPos, 0));
      xPos += deltaX;
    }

    points = data.Noise1.compute_Line(points, yNoise);
    points = data.Noise2.compute_Line(points, yNoise);

  }

  void draw()
  {

    current_graphics.noFill();
    current_graphics.beginShape();

    for (int i = 0; i < points.size(); i++)
    {
      PVector pA = points.get(i);
      current_graphics.vertex(pA.x, pA.y + y_line);
    }

    current_graphics.endShape();
  }

  void mergeWith(Line prevLine)
  {
    for (int i = 0; i < data.main.XSteps; i++)
    {
      float y = points.get(i).y + y_line;
      float prev_y =  prevLine.points.get(i).y + prevLine.y_line;

      if (y > prev_y)
        points.get(i).y = prev_y - y_line;
    }
  }
}

class DrawingGenerator
{
  DrawingData data;

  ArrayList<Line> lines;

  int lastUpdate  = 0;

  void update()
  {
    noiseSeed(data.main.seed);
    noiseDetail(data.main.NoiseLod, data .main.NoiseFalloff);
    
    my_noiseSeed(data.main.seed);
    my_noiseDetail(data.main.NoiseLod, data .main.NoiseFalloff);

    lines = new ArrayList<Line>();

    data.Noise1.computePowS();
    data.Noise2.computePowS();

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
    for (int lineIndex = 0; lineIndex < data.main.NbLines; lineIndex++)
    {
      Line line = new Line();
      line.build(data, y_Noise, y_Line);

      if (data.main.intersection)
        if (prevLine != null)
          line.mergeWith(prevLine);

      prevLine = line;

      lines.add(line);
      y_Noise += delta_y_Noise;
      y_Line += delta_y;
    }
  }

  void draw()
  {
    boolean needUpdate = false;
   
    if (data.changed)
    {
      needUpdate = true;
      data.changed = false;
    }

    int delta_ms =  millis() - lastUpdate;
    lastUpdate =  millis();

    if (data.main.move.x != 0 || data.main.move.y != 0)
    {
      data.main.pos.x += 0.001*data.main.move.x * delta_ms * data.main.moveSpeed * data.Noise1.pow_X;
      data.main.pos.y += 0.001*data.main.move.y * delta_ms  * data.main.moveSpeed * data.Noise1.pow_Y;

      needUpdate = true;
    }

    if (needUpdate)
      drawer.update();


    for (int lineIndex = 0; lineIndex < lines.size(); lineIndex++)
    {
      lines.get(lineIndex).draw();
    }
  }
}
