  void keyPressed() {
    if (key == CODED) {  
      if (keyCode == UP) 
        data.move.y = -1;
      else if (keyCode == DOWN)
        data.move.y = 1;
      else if (keyCode == LEFT)
        data.move.x = -1;
      else if (keyCode == RIGHT)
        data.move.x = 1;
    }
  }  

  void keyReleased() {
    if (key == CODED) {

      if (keyCode == UP) 
        data.move.y = 0;
      else if (keyCode == DOWN)
        data.move.y = 0;
      else if (keyCode == LEFT)
        data.move.x = 0;
      else if (keyCode == RIGHT)
        data.move.x = 0;
    }
  }
  
  
