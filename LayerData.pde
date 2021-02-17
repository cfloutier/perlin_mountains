

class LayerData
{
  float xNoise = 0.4;
  float yNoise = 0.4;
  float Height_Noise = 5;
  
  float Added_Height = 0;

  int xNoise_Mul = 1;
  int yNoise_Mul = 1;
  int Height_Mul = 1;
 
  
  boolean add = true;
  
  ArrayList<PVector> compute_Line(ArrayList<PVector> points, float y)
  {
    
    float deltaX = ((float)width) /  (data.XSteps-1);
    float x =  0;
    if (points == null)
    {
      points = new ArrayList<PVector>();
      for (int i = 0; i < data.XSteps; i++)
      {
        points.add(new PVector(x, 0));
        x = x + deltaX;
      }
    }
    
    x =  0;
     
    for (int i = 0; i < data.XSteps; i++)
    {   
      float h = Height_Noise * (noise(
            data.pos.x + x * xNoise/100 * pow(10,xNoise_Mul), 
            data.pos.y + y * yNoise/100 * pow(10,yNoise_Mul)
            )-0.5) * pow(10,Height_Mul) - Added_Height;
            
      x = x + deltaX;
             
      PVector prevPoint = points.get(i);
      
      PVector newPoint = null;
      if (add)
        newPoint = new PVector(x, h + prevPoint.y );   
      else
      {
        float min = min(prevPoint.y, h);
        newPoint = new PVector(x, min);   
      }
        
     
      points.set(i, newPoint);
     
    }
    
    return points;
  }

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    xNoise = src.getFloat("xNoise", xNoise);
    yNoise = src.getFloat("yNoise", yNoise);
    Height_Noise = src.getFloat("Height_Noise", Height_Noise);
    Added_Height = src.getFloat("Added_Height", Added_Height);
    

    xNoise_Mul = src.getInt("xNoise_Mul", xNoise_Mul);
    yNoise_Mul = src.getInt("yNoise_Mul", yNoise_Mul);
    Height_Mul = src.getInt("Height_Mul", Height_Mul);
  }


  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();
    dest.setFloat("xNoise", xNoise);
    dest.setFloat("yNoise", yNoise);
    dest.setFloat("Height_Noise", Height_Noise);
    dest.setFloat("Added_Height", Added_Height);
    

    dest.setInt("xNoise_Mul", xNoise_Mul);
    dest.setInt("yNoise_Mul", yNoise_Mul);
    dest.setInt("Height_Mul", Height_Mul);

    return dest;
  }
}
