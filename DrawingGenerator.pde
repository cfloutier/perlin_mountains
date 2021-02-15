 //<>//

class Line
{
  ArrayList<PVector> points = new ArrayList<PVector>();

  void build(DrawingData data, float y)
  {
    points = new ArrayList<PVector>();

    float deltaX = ((float)width) /  (data.XSteps-1);
    float x =  0;

    for (int i = 0; i < data.XSteps; i++)
    {
      float h1 = data.HeightLine1 * (noise(        data.pos.x + x*data.xNoise1/100, data.pos.y + y*data.yNoise1/100)-0.5);
      float h2 = data.HeightLine2 * (noise(5000  + data.pos.x + x*data.xNoise2/100, 5000 +  data.pos.y + y*data.yNoise2/100)-0.5);
      points.add(new PVector(x, y + h1 + h2));
      x = x + deltaX;
    }
  }

  void draw()
  {
    noFill();
    beginShape();
    for (int i = 0; i < points.size(); i++)
    {
      PVector pA = points.get(i);

      vertex(pA.x, pA.y);
    }
    endShape();
  }

  void mergeWith(Line prevLine)
  {
    for (int i = 0; i < data.XSteps; i++)
    {
      if (points.get(i).y > prevLine.points.get(i).y)
        points.get(i).y = prevLine.points.get(i).y;
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

    if (data.XSteps < 10) 
      data.XSteps = 10;

    float total_h = height * data.Height;
    float yPos = height/2 + total_h/2;
    float YDeltaPos = total_h / data.NbLines;

    Line prevLine = null;
    for (int lineIndex = 0; lineIndex < data.NbLines; lineIndex++)
    {
      Line line = new Line();
      line.build(data, yPos);

      if (data.intersection)
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
    if (data.changed)
    {
      needUpdate = true;
      data.changed = false;
    }

    int delta =  millis() - lastUpdate;
    lastUpdate =  millis();
    if (data.move.x != 0 || data.move.y != 0)
    {

      if (data.xNoise1 != 0)
        data.pos.x += 0.001*data.move.x * delta * data.moveSpeed * data.xNoise1;

      if (data.yNoise1 != 0)
        data.pos.y += 0.001*data.move.y * delta  * data.moveSpeed * data.yNoise1;

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
