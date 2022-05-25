
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

  tabs();
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
