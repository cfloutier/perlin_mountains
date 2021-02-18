
void addFileTab()
{
  cp5.addTab("Files");

  float xPos = 0;
  float yPos = 20;

  int widthButton = 100;
  int heightButton = 20;

  cp5.addButton("LoadJson")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");        

  xPos += widthButton;

  cp5.addButton("SaveJson")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");    

  yPos += heightButton;
  xPos = 0;

  cp5.addButton("ExportPDF")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");      

  xPos += widthButton;

/*  cp5.addButton("ExportDXF")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");      

  xPos += widthButton;
*/

  cp5.addButton("ExportSVG")
    .setPosition(xPos, yPos)
    .setSize(widthButton, heightButton)
    .moveTo("Files");    

  xPos += widthButton;
}

void LoadJson()
{
  File file = new File(".");
  selectInput("Select data file ", "loadSelected", file);
}

void loadSelected(File selection) 
{
  if (selection == null) 
  {
  } else 
  {
    data.LoadJson(selection.getAbsolutePath());
    data.name = selection.getName();
    data.name = data.name.substring(0, data.name.length() - 5);
    print (data.name);
    dataGui.setGUIValues();
  }
}

void SaveJson()
{
  selectInput("Save data file ", "saveSelected");
}

void saveSelected(File selection) 
{
  if (selection == null) 
  {
  } else 
  {
    String path = selection.getAbsolutePath();
    if (path.length() < 5 || !path.substring(path.length() - 5).equals(".json"))
      path = path + ".json";

    data.SaveJson(path);
    
    data.name = selection.getName();
    data.name = data.name.substring(0, data.name.length() - 5);
    print (data.name);
  }
}

boolean record = false;
int mode  = 0;

String fileName = "";
void ExportPDF()
{
  record = true;
  mode = 0;
}

void ExportDXF()
{
  record = true;
  mode = 1;
}  

void ExportSVG()
{
  record = true;
  mode = 2;
}
