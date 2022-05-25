
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

//import oscP5.*;

KetaiBluetooth bt;
String info = "";
KetaiList klist;

ArrayList<String> devicesDiscovered = new ArrayList();
boolean isConfiguring = true;

int CONNECT_LIST = 0; 
int DISCONNECT_LIST = 1;
int listState = CONNECT_LIST;

int uiScale = 4;

float btBrightness, btBrightnessPrevious, btScale, btScalePrevious, btSpeed, btSpeedPrevious;

boolean themeSwitch, r;

TextInput input = new TextInput(" ");
DropDown drop = new DropDown();

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
  println("Creating KetaiBluetooth");
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

//********************************************************************

void setup()
{   
  fullScreen();
  uiSetScale(uiScale);
  smooth(8);

  bt.start();

  //   PFont font;
  // // чтобы шрифт загрузился корректно, 
  // // он должен находиться в папке «data» текущего скетча:
  // font = createFont("BalooDa2-Regular.ttf", 32);
  // textFont(font);
}

void drawBTConnect(int pos_x, int pos_y) {
  if (bt.getConnectedDeviceNames().isEmpty()) {
    push();
    fill(255, 0, 0);
    rect(pos_x, pos_y, 20, 20);
    pop();
  } else {
    push();
    fill(0, 255, 0);
    rect(pos_x, pos_y, 20, 20);
    pop();
  }
}

void draw() {

  uiFill();
  // uiLight();
  if(themeSwitch){
    uiDark();
  }else{
    uiLight();
  }

  beginCard(0, 0, width, height);

  uiSetScale(uiScale);

  LabelCenter("ArduinoLamp", 16, card_x+(width/2), card_y+86);

  uiResetStep(card_y+300);

  // if (bt.getConnectedDeviceNames().isEmpty()) {
  //   push();
  //   fill(255, 0, 0);
  //   rect(card_x+400+s_med/2+50, card_y+100, 20, 20);
  //   pop();
  // } else {
  //   push();
  //   fill(0, 255, 0);
  //   rect(card_x+400+s_med/2+50, card_y+100, 20, 20);
  //   String info="";
  //   ArrayList<String> devices = bt.getConnectedDeviceNames();  // 20
  //   for (String device : devices)
  //   {
  //     info+= device+"\n";
  //   }
  //   text(info, card_x+400+s_med/2+80, card_y+120);
  //   pop();
  // }

  if (Button("Connect", card_x+(width/2)-330, uiStep(), 320)) {

    String btInfo = "";
    listState = CONNECT_LIST;

    if (bt.getDiscoveredDeviceNames().size() > 0) {
      ArrayList<String> list = bt.getDiscoveredDeviceNames();
      list.add("CANCEL");
      klist = new KetaiList(this, list);
    } else if (bt.getPairedDeviceNames().size() > 0) {
      ArrayList<String> list = bt.getPairedDeviceNames();
      list.add("CANCEL");
      klist = new KetaiList(this, list);
    }
  }

  if (Button("Disconnect", card_x+(width/2)+10, uiPrevStep(), 320)) {

    String btInfo = "";
    listState = DISCONNECT_LIST;

    if (bt.getDiscoveredDeviceNames().size() > 0) {
      ArrayList<String> list = bt.getDiscoveredDeviceNames();
      list.add("CANCEL");
      klist = new KetaiList(this, list);
    } else if (bt.getPairedDeviceNames().size() > 0) {
      ArrayList<String> list = bt.getPairedDeviceNames();
      list.add("CANCEL");
      klist = new KetaiList(this, list);
    }
  }

  uiResetStep(int(height/3.25));

  if (Button("I/O", card_x+(width/2)-110, uiStep()-(110/2), 220, 220)) {
    String m = "$1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button(">>", card_x+(width/2)+120, uiPrevStep(), 256)) {
    String m = "$2,1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button("<<", card_x+(width/2)-376, uiPrevStep(), 256)) {
    String m = "$2,0;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  // uiTextSize(int(6*3.5));

  uiResetStep(1010);

  // ===================================== Brightness =====================================
  int brightnessTemp = int(btBrightness);
  int brightnessTempPrevious = int(btBrightnessPrevious);

  if (Button("-", card_x+100, uiStep(), 140, 140)) {
    if (btBrightness > 0) {
      btBrightness -= 1.0;
    }
  }

  LabelCenter("Brightness: " + str(int(btBrightness)), 12, card_x+(width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, card_x+800, uiPrevStep());

  if (Button("+", card_x+840, uiPrevStep(), 140, 140)) {
    if (btBrightness <= 255) {
      btBrightness += 1.0;
    }
  }

  btBrightness = Slider(btBrightness, card_x+(width/2)-845/2, uiStep(), 845, s_height);



  if (brightnessTemp != brightnessTempPrevious) {
    String bcString = "$4," + str(brightnessTemp) + ";";
    bt.broadcast(bcString.getBytes());

    println(bcString);

    btBrightnessPrevious = btBrightness;
    brightnessTemp = brightnessTempPrevious;
  }

  // ===================================== Scale =====================================

  // Divider((width-(width-50))/2,uiStep(), width-50, 2);

  uiResetStep(uiStep()+50);

  int scaleTemp = int(btScale);
  int scaleTempPrevious = int(btScalePrevious);

  if (Button("-", card_x+100, uiStep(), 140, 140)) {
    if (btScale > 0) {
      btScale -= 1.0;
    }
  }

  LabelCenter("Scale: " + str(int(btScale)), 12, card_x+(width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, card_x+800, uiPrevStep());

  if (Button("+", card_x+840, uiPrevStep(), 140, 140)) {
    if (btScale <= 255) {
      btScale += 1.0;
    }
  }


  btScale = Slider(btScale, card_x+(width/2)-845/2, uiStep(), 845, s_height);

  if (scaleTemp!= scaleTempPrevious) {
    String bcString = "$5," + str(scaleTemp) + ";";
    bt.broadcast(bcString.getBytes());
    println(bcString);
    btScalePrevious = btScale;
    scaleTemp = scaleTempPrevious;
  }



  // ===================================== Speed =====================================
  uiResetStep(uiStep()+50);

  int speedTemp = int(btSpeed);
  int speedTempPrevious = int(btSpeedPrevious);

  if (Button("-", card_x+100, uiStep(), 140, 140)) {
    if (btSpeed > 0) {
      btSpeed -= 1.0;
    }
  }

  LabelCenter("Speed: " + str(int(btSpeed)), 12, card_x+(width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, card_x+800, uiPrevStep());

  if (Button("+", card_x+840, uiPrevStep(), 140, 140)) {
    if (btSpeed <= 255) {
      btSpeed += 1.0;
    }
  }



  btSpeed = Slider(btSpeed, card_x+(width/2)-845/2, uiStep(), 845, s_height);

  if (speedTemp!= speedTempPrevious) {
    String bcString = "$6," + str(speedTemp) + ";";
    bt.broadcast(bcString.getBytes());
    println(bcString);
    btSpeedPrevious = btSpeed;
    speedTemp = speedTempPrevious;
  }

  // ===================================== Save =====================================
  if (Button("Save", card_x+(width/2)-128, uiStep(), 256)) {
    String m = "$3;";
    bt.broadcast(m.getBytes());
    println(m);
  }

themeSwitch = Toggle(themeSwitch, card_x+(width-(width/4)), uiStep()+20, 80, 50);

  endCard();
}


void onBluetoothDataEvent(String who, byte[] data)
{
}

String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: " + bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device : devices)
  {
    btInfo += device + "\n";
  }

  return btInfo;
}

void onKetaiListSelection(KetaiList klist)
{

  String selection = klist.getSelection();

  if (listState == CONNECT_LIST)
  {
    if (!selection.equals("CANCEL")) {
      bt.connectToDeviceByName(selection);
    }
  } else if (listState == DISCONNECT_LIST)
  {
    bt.disconnectDevice(selection);
  }
  klist = null;
}
