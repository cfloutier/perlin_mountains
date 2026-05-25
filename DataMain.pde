class DataMain extends GenericData
{
  DataMain()
  {  
    super("Main");
  }
  
  int NbLines = 100;

  int XSteps = 300;
  float HeightRatio = 0.5;

  int Width = 1200;

  int seed; 
  boolean intersection = true;

  float moveSpeed_X = 1;
  float moveSpeed_Y = 1;

  int NoiseLod = 4;
  float NoiseFalloff = 0.5;

  int max_override = 5;

  void setSeed()
  {
    seed = (int) random(0, 100000000);
    changed = true;
  }

}

class MainGUI extends GUIPanel
{
  DataMain main;
  MainGUI(DataMain main)
  {
    super("Main", main);
    this.main = main;
  }
  
  Slider NbLines;
  Slider XSteps;
  Slider HeightRatio;
  Slider Width;
  Toggle intersection;

  Slider moveSpeed_X;
  Slider moveSpeed_Y;

  Slider max_override;
  
  Button seedBt;
  Textlabel seedLabel;

  Slider NoiseLod;
  Slider NoiseFalloff;

  void setGUIValues()
  {
    NbLines.setValue(main.NbLines);
    XSteps.setValue(main.XSteps);
    HeightRatio.setValue(main.HeightRatio);
    Width.setValue(main.Width);

    intersection.setValue(main.intersection);

    max_override.setValue(main.max_override);
    
    moveSpeed_X.setValue(main.moveSpeed_X);
    moveSpeed_Y.setValue(main.moveSpeed_Y);
    
    seedLabel.setText("seed : " + main.seed);

    NoiseLod.setValue(main.NoiseLod);
    NoiseFalloff.setValue(main.NoiseFalloff);
  }

  void setupControls()
  {
    super.Init();

    main = data.main;

    addLabel("Sizes");

    Width = addIntSlider("Width", "Canvas Width", 100, 3000);
    HeightRatio = addSlider("HeightRatio", "Height Ratio", 0, 2);

    nextLine();
    addLabel("Page");

    NbLines = addSlider("NbLines", "Nb of Lines", 1, 1000);
    XSteps = addSlider("XSteps", "X Steps", 4, 2000);

    nextLine();

    intersection = addToggle( "intersection", "intersection");
    max_override = addIntSlider( "max_override", "Max override", 0, 50);

    nextLine();

    addLabel("Move");

    moveSpeed_X = addSlider("moveSpeed_X", "Move Speed X", 0, 1);
    moveSpeed_Y = addSlider("moveSpeed_Y", "Move Speed Y", 0, 1);
    
    nextLine();
    addLabel("Random");

    seedLabel = addLabel("Random");
    seedBt = addButton("Random seed");
    
    nextLine();
    seedBt.plugTo(main, "setSeed"); 

    NoiseLod = addIntSlider("NoiseLod", "Noise Harmonics", 1, 8);
    NoiseFalloff = addSlider("NoiseFalloff", "NoiseFalloff", 0, 1);
  }

  void update_ui()
  {
    seedLabel.setText("seed : " + main.seed);
  }
}
