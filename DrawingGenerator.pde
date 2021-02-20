 //<>// //<>//

class Line
{
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  float y_line = 0;

  void build(DrawingData data, float y)
  {
    points = null;
    
    y_line = y;
    
    points = new ArrayList<PVector>();
    for (int i = 0; i < data.main.XSteps; i++)
    {
      points.add(new PVector(0, 0));
    }
    
    points = data.Noise1.compute_Line(points, y);
  
    //print(", " + y);
    points = data.Noise2.compute_Line(points, y);
  }

  void draw()
  {
    noFill();
    beginShape();
   
   
    for (int i = 0; i < points.size(); i++)
    {
      PVector pA = points.get(i);

      vertex(pA.x, pA.y + y_line);
    }
    endShape();
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
    randomSeed(10);
    lines = new ArrayList<Line>();

    if (data.main.XSteps < 10) 
      data.main.XSteps = 10;
      
    data.Noise1.computePowS();
    data.Noise2.computePowS();
    
    float total_h = height * data.main.Height;
    float yPos = height/2 + total_h/2;
    float YDeltaPos = total_h / data.main.NbLines;

    Line prevLine = null;
    for (int lineIndex = 0; lineIndex < data.main.NbLines; lineIndex++)
    {
      Line line = new Line();
      line.build(data, yPos);

      if (data.main.intersection)
        if (prevLine != null)
          line.mergeWith(prevLine);

      prevLine = line;

      lines.add(line);

      yPos -= YDeltaPos;
    }
  }

  void draw()
  {
    boolean needUpdate = false;
    noiseSeed(data.main.seed);
    if (data.changed)
    {
      needUpdate = true;
      data.changed = false;
    }

    int delta =  millis() - lastUpdate;
    lastUpdate =  millis();
    if (data.main.move.x != 0 || data.main.move.y != 0)
    {

      if (data.Noise1.xNoise != 0)
        data.main.pos.x += 0.001*data.main.move.x * delta * data.main.moveSpeed * data.Noise1.xNoise;

      if (data.Noise1.yNoise!= 0)
        data.main.pos.y += 0.001*data.main.move.y * delta  * data.main.moveSpeed * data.Noise1.yNoise;

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
