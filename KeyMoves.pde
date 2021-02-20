  void keyPressed() {
    if (key == CODED) {  
      if (keyCode == UP) 
        data.main.move.y = -1;
      else if (keyCode == DOWN)
        data.main.move.y = 1;
      else if (keyCode == LEFT)
        data.main.move.x = -1;
      else if (keyCode == RIGHT)
        data.main.move.x = 1;
    }
  }  

  void keyReleased() {
    if (key == CODED) {

      if (keyCode == UP) 
        data.main.move.y = 0;
      else if (keyCode == DOWN)
        data.main.move.y = 0;
      else if (keyCode == LEFT)
        data.main.move.x = 0;
      else if (keyCode == RIGHT)
        data.main.move.x = 0;
    }
  }
  
  
