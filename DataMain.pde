
class DataMain extends GenericDataClass
{
  DataMain()
  {  
    super("Main");
  }
  
  int NbLines = 100;

  int XSteps = 300;
  float Height = 0.5;

  int seed; 
  boolean intersection = true;

  float moveSpeed_X = 1;
  float moveSpeed_Y = 1;

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

    seed = src.getInt("seed", seed);

    intersection = src.getBoolean("intersection", intersection);
    moveSpeed_X = src.getFloat("moveSpeed_X", moveSpeed_X);
    moveSpeed_Y = src.getFloat("moveSpeed_Y", moveSpeed_Y);

    NoiseLod = src.getInt("NoiseLod", NoiseLod);
    NoiseFalloff = src.getFloat("NoiseFalloff", NoiseFalloff);
  }

  JSONObject SaveJson()
  {
    JSONObject dest = new JSONObject();

    dest.setInt("NbLines", NbLines);
    dest.setFloat("Height", Height);
    dest.setInt("XSteps", XSteps);



    dest.setInt("seed", seed);

    dest.setBoolean("intersection", intersection);

    dest.setFloat("moveSpeed_X", moveSpeed_X);
    dest.setFloat("moveSpeed_Y", moveSpeed_Y);

    dest.setInt("NoiseLod", NoiseLod);
    dest.setFloat("NoiseFalloff", NoiseFalloff);

    return dest;
  }
}


class MainGUI extends GUIPanel
{
  
  
  
  DataMain main;

  Slider NbLines;
  Slider XSteps;
  Slider Height;
  Toggle intersection;

  Slider moveSpeed_X;
  Slider moveSpeed_Y;

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
    
    moveSpeed_X.setValue(main.moveSpeed_X);
    moveSpeed_Y.setValue(main.moveSpeed_Y);
    
    seedLabel.setText("seed : " + main.seed);

    NoiseLod.setValue(main.NoiseLod);
    NoiseFalloff.setValue(main.NoiseFalloff);
  }

  void setupControls()
  {
    super.Init("Main", data.main);

    main = data.main;

    addLabel("Page");

    NbLines = addSlider("NbLines", "Nb of Lines", 1, 1000, true);
    XSteps = addSlider("XSteps", "X Steps", 4, 2000, false);

    Height = addSlider("Height", "Drawing Height", 0, 1, false);

    intersection = addToggle( "intersection", "intersection", false);

    addLabel("Move");

    moveSpeed_X = addSlider("moveSpeed_X", "Move Speed X", 0, 2, true);
    moveSpeed_Y = addSlider("moveSpeed_Y", "Move Speed Y", 0, 2, false);
    
    addLabel("Random");

    seedLabel = addLabel("Random");

    seedBt = addButton("Random seed");
    seedBt.plugTo(main, "setSeed"); 

    NoiseLod = addIntSlider("NoiseLod", "Noise Harmonics", 1, 8, false);
    NoiseFalloff = addSlider("NoiseFalloff", "NoiseFalloff", 0, 1, false);
  }


  void update()
  {
    seedLabel.setText("seed : " + main.seed);
  }
}
