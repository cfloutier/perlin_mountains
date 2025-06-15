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
    dataGui.key_move = move;
    //dataGui.tab_name = cp5.getWindow( ).getCurrentTab().getName();
    //print(data.tab_name);
  }
  
