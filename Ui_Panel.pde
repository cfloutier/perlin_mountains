class UI_Panel implements ControlListener
{
  String pageName;  
  ControlP5 cp5;

  float xPos = 0;
  float yPos = 0;

  int xspace = 15;

  int widthCtrl = 300;
  int heightCtrl = 20;


  int indexLabel = 0;


  void Init(String pageName, ControlP5 cp5)
  {
    this.pageName = pageName;
    this.cp5 = cp5;

    cp5.addListener(this);  

    yPos = 20;
  }


  public void controlEvent(ControlEvent theEvent) {
    data.changed = true;
  }


  Slider addSlider(String name, Object data_Class, float min, float max, boolean horizontal)
  {
    Slider s = cp5.addSlider(data_Class, name)   
      .setPosition(xPos, yPos)
      .setSize(widthCtrl, heightCtrl)
      .setRange(min, max)
      .moveTo(pageName);

    if (horizontal)
    {
      xPos += xspace + widthCtrl;
    } else
    {
      yPos+=heightCtrl+2;
      xPos = 0;
    }


    controlP5.Label l = s.getCaptionLabel();
    l.getStyle().marginTop = 0; //move upwards (relative to button size)
    l.getStyle().marginLeft = -55; //move to the right

    return s;
  }


  Textlabel addLabel(String content)
  {
    Textlabel l = cp5.addTextlabel("Label" + indexLabel)
      .setText(content)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)  
      .moveTo(pageName);

    yPos += 15;

    indexLabel++;

    return l;
  }


  Toggle addToggle(String name, Object data_Class)
  {

    Toggle t = cp5.addToggle(data_Class, name)
      .setPosition(xPos, yPos)
      .setSize(100, heightCtrl)  
      .setMode(ControlP5.SWITCH)
      .moveTo(pageName);

    yPos+=heightCtrl+2;

    //t.setLabel("The Toggle Name");
    controlP5.Label l = t.getCaptionLabel();
    l.getStyle().marginTop = -heightCtrl + 2; //move upwards (relative to button size)
    l.getStyle().marginLeft = 10; //move to the right

    return t;
  }
}
