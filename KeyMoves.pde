  void keyPressed() {
    
    if (key == CODED) {  
      if (keyCode == UP) 
        move(new PVector(0, -1));
      else if (keyCode == DOWN)
        move(new PVector(0, 1));
      else if (keyCode == LEFT)
        move(new PVector(-1, 0));
      else if (keyCode == RIGHT)
        move(new PVector(1, 0));
    }
  }  

  void keyReleased() {
    if (key == CODED) {
      if (keyCode == UP) 
        move(new PVector(0, 0));
      else if (keyCode == DOWN)
        move(new PVector(0, 0));
      else if (keyCode == LEFT)
        move(new PVector(0, 0));
      else if (keyCode == RIGHT)
        move(new PVector(0, 0));
    }
  }
  
  void move(PVector move)
  {
    data.move = move;
    data.tab_name = cp5.getWindow( ).getCurrentTab().getName();
    
    print(data.tab_name);
  }
  
  int lastUpdate = 0;
  
  boolean checkMove( )
  {
    if (data.move.x != 0 || data.move.y != 0)
    {
      DataLayer layer = null;
      switch(data.tab_name)
      {
        case "Layer 1":
          layer = data.Noise1;
          break;
        case "Layer 2":
          layer = data.Noise2;
          break;        
        case "Layer 3":
          layer = data.Noise3;
          break;        
      }
      
      if (layer != null)
      {
        int delta_ms =  millis() - lastUpdate;
        layer.pos.x += 0.001*data.move.x * delta_ms * data.main.moveSpeed_X * layer.pow_X;
        layer.pos.y += 0.001*data.move.y * delta_ms  * data.main.moveSpeed_Y * layer.pow_Y;   
        
        println("layer.pos.x " + layer.pos.x);
      }
      
      lastUpdate =  millis();
      
      return true;
    }
    
    lastUpdate =  millis();
    
    return false;
  }
