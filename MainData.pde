
class MainData
{
  int NbLines = 100;

  int XSteps = 300;
  float Height = 0.5;

  int seed; 
  boolean intersection = true;

  PVector pos = new PVector(0, 0);

  float moveSpeed = 1;
  PVector move = new PVector(0, 0);
  
  int NoiseLod = 4;
  float NoiseFalloff = 0.5;
  
  void setSeed()
  {
    seed = (int) random(0, 100000000);
  }

  void LoadJson(JSONObject src)
  {
    if (src == null)
      return;

    NbLines = src.getInt("NbLines", NbLines);
    Height = src.getFloat("Height", Height);
    XSteps = src.getInt("XSteps", XSteps);

    pos = new PVector(
      src.getFloat("pos_x", pos.x), 
      src.getFloat("pos_y", pos.y)
      );

    seed = src.getInt("seed", seed);

    intersection = src.getBoolean("intersection", intersection);
    moveSpeed = src.getFloat("moveSpeed", moveSpeed);
    
    NoiseLod = src.getInt("NoiseLod", NoiseLod);
    NoiseFalloff = src.getFloat("NoiseFalloff", NoiseFalloff);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();

    dest.setInt("NbLines", NbLines);
    dest.setFloat("Height", Height);
    dest.setInt("XSteps", XSteps);

    dest.setFloat("pos_x", pos.x);
    dest.setFloat("pos_y", pos.y);

    dest.setInt("seed", seed);

    dest.setBoolean("intersection", intersection);

    dest.setFloat("moveSpeed", moveSpeed);
    
     dest.setInt("NoiseLod", NoiseLod);
     dest.setFloat("NoiseFalloff", NoiseFalloff);

    return dest;
  }
}


class MainGUI extends UI_Panel
{
  MainData main;

  Slider NbLines;
  Slider XSteps;
  Slider Height;
  Toggle intersection;
 
  Slider moveSpeed;
  
  Button seedBt;
  Textlabel seedLabel;

  Slider NoiseLod;
  Slider NoiseFalloff;
  
  void setGUIValues()
  {
    NbLines.setValue(main.NbLines);
    XSteps.setValue(main.XSteps);
    Height.setValue(main.Height);

    intersection.setValue(main.intersection);
    moveSpeed.setValue(main.moveSpeed);
    seedLabel.setText("seed : " + main.seed);
    
    NoiseLod.setValue(main.NoiseLod);
    NoiseFalloff.setValue(main.NoiseFalloff);
  }

  void setupControls(ControlP5 cp5)
  {
    super.Init("Main", cp5);

    main = data.main;


    addLabel("Page");

    NbLines = addSlider("NbLines", "Nb of Lines", main, 1, 1000, true);
    XSteps = addSlider("XSteps", "X Steps", main, 4, 2000, false);

    Height = addSlider("Height", "Drawing Height", main, 0, 1, false);

    intersection = addToggle( "intersection", "intersection", main);

    addLabel("Interaction");

    moveSpeed = addSlider("moveSpeed", "Move Speed", main, 0, 10, false);

    seedLabel = addLabel("Random");
 
    seedBt = addButton("Random seed");
    seedBt.plugTo(main, "setSeed"); 
    
    NoiseLod = addIntSlider("NoiseLod", "Noise Harmonics", main, 1, 8, false);
    NoiseFalloff = addSlider("NoiseFalloff", "NoiseFalloff", main, 0, 1, false);
  }
  
  
  void update()
  {
    seedLabel.setText("seed : " + main.seed);
    
  }
}
