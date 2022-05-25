
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

//import oscP5.*;

String[] file;

PrintWriter output;

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

  file = loadStrings("settings.txt");
  if (file == null) {
    println("Settings text file is empty\nCreate new file");
    file = new String[1];
    file[0] = "1";
    saveStrings("settings.txt", file);
  }
  // println(file);

  // ===================================== Запись в файл =====================================
  // file[0] = "0";
  // saveStrings("setttingss.txt", file);
  // for (int i = 0; i < file.length; i++) {
  //     info+=file[i]+"\n";
  // }
  // ===================================== Запись в файл =====================================

  //   PFont font;
  // // чтобы шрифт загрузился корректно, 
  // // он должен находиться в папке «data» текущего скетча:
  // font = createFont("BalooDa2-Regular.ttf", 32);
  // textFont(font);
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
