
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

//import oscP5.*;

String[] file;

KetaiBluetooth bt;
String info = "";
KetaiList klist;

ArrayList<String> devicesDiscovered = new ArrayList();
byte isConfiguring = 1;

int CONNECT_LIST = 0; 
int DISCONNECT_LIST = 1;
int listState = CONNECT_LIST;
boolean connectStarted = false;

int uiScale = 4;

int timeTicker = 0;

String connectedDevice = "";

float btBrightness, btBrightnessPrevious, btScale, btScalePrevious, btSpeed, btSpeedPrevious;

boolean timeTicker(int msc) {
  if (millis() - timeTicker >= msc) {
    timeTicker = millis();
    return true;
  } else {
    return false;
  }
}

boolean isConnectedToDevice() {
  if (bt.getConnectedDeviceNames().isEmpty()) return false;
  else return true;
}

void autoConnection() {
  if (!isConnectedToDevice() && autoConnect && !connectStarted) {
    if (connectedDevice.length() > 0 && listState != DISCONNECT_LIST) {
      listState = CONNECT_LIST;

      if (bt.getPairedDeviceNames().size() > 0) {
        bt.connectToDeviceByName(connectedDevice);
        connectStarted = true;
      }
    }
  }
}

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

  // ===================================== Чтение и апись файла =====================================
  file = loadStrings("settings.txt");
  if (file == null) {
    println("Settings text file is empty\nCreate new file");
    file = new String[3];
    file[0] = "1";
    file[1] = "false";
    file[2] = "";
    saveStrings("settings.txt", file);
  }
  themeSwitch = int(file[0]);
  autoConnect = boolean(file[1]);
  connectedDevice = file[2];
  // println("*" + file[2] + "*");
  // ===================================== Чтение и апись файла =====================================

  // ===================================== Шрифт =====================================
  PFont font;
  font = createFont("fonts/BalooDa2-SemiBold.ttf", 32);
  textFont(font);
  // ===================================== Шрифт =====================================
}

void draw() {
  autoConnection();
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
      connectedDevice = selection;
    }
  } else if (listState == DISCONNECT_LIST && !selection.equals("CANCEL"))
  {
    bt.disconnectDevice(selection);
  }
  klist = null;
}
