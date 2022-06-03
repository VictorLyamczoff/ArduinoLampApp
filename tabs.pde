// ===================================== Цвета =====================================
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color white = color(255, 255, 255);
color black = color(0, 0, 0);
// =================================================================================


// ===================================== Иконки =====================================
PImage logo;

String iconPowerDark = "svg/dark/power-off";
String iconPowerLight = "svg/light/power-off";
String iconPower = iconPowerLight;

String iconNextDark = "svg/dark/next";
String iconNextLight = "svg/light/next";
String iconNext = iconNextLight;

String iconPrevDark = "svg/dark/previous";
String iconPrevLight = "svg/light/previous";
String iconPrev = iconPrevLight;

String iconPlusDark = "svg/dark/plus";
String iconPlusLight = "svg/light/plus";
String iconPlus = iconPlusLight;

String iconMinusDark = "svg/dark/minus";
String iconMinusLight = "svg/light/minus";
String iconMinus = iconMinusLight;

String iconThemeDark = "svg/dark/icon_dark_theme";
String iconThemeLight = "svg/light/icon_light_theme";
String iconTheme = iconThemeLight;
// =================================================================================

byte curTab = 0;

int themeSwitch = 1;

Toggle switchTheme = new Toggle();

String btStatus = "";

boolean autoConnect = false;

void tabs() {
  uiFill();

  uiSetScale(uiScale);

  int w = width / 2;
  int h = w / 4;
  int y = height - h;

  if (Button("Effects", 0, y, w, h, false)) {
    curTab = 0;
  }

  if (Button("Settings", w*1, y, w, h, false)) {
    curTab = 1;
  }

  if (curTab == 0) effTab();
  if (curTab == 1) cfgTab();

  if (themeSwitch == 1) {
    uiDark();

    iconPower = iconPowerLight;
    iconNext = iconNextLight;
    iconPrev = iconPrevLight;
    iconPlus = iconPlusLight;
    iconMinus = iconMinusLight;
    iconTheme = iconThemeLight;
  } else {
    uiLight();

    iconPower = iconPowerDark;
    iconNext = iconNextDark;
    iconPrev = iconPrevDark;
    iconPlus = iconPlusDark;
    iconMinus = iconMinusDark;
    iconTheme = iconThemeDark;
  }
}

void drawBTConnect(int pos_x, int pos_y, int size, boolean center) {

  if (isConnectedToDevice()) {
    btStatus="";
    ArrayList<String> devices = bt.getConnectedDeviceNames();
    for (String device : devices)
    {
      btStatus = "Connect to "+device;
    }
    fill(green);
    textSize(int(size*_ui_scale));
    if (center) textAlign(CENTER, CENTER);
    else textAlign(LEFT, CENTER);
    text("Status: "+btStatus, pos_x, pos_y+20);
  } else {
    fill(red);
    textSize(int(size*_ui_scale));
    if (center) textAlign(CENTER, CENTER);
    else textAlign(LEFT, CENTER);
    text("Status: Not connected", pos_x, pos_y+10);
  }
}

void effTab() {

  int w = width / 2;
  int h = w / 4;
  int y = height - h;


  noStroke();
  fill(c_hover);
  rect(0, y-6, w, 4, 2);

  if (themeSwitch == 1) {
    logo = loadImage("png/light/logo.png");
    image(logo, width/2-325, 100, 650, 150);
  } else if (themeSwitch == 0) {
    logo = loadImage("png/dark/logo.png"); 
    image(logo, width/2-325, 100, 650, 150);
  }


  uiResetStep(300);

  if (Button("Connect", (width/2)-330, uiStep(), 320, true)) {

    if (!isConnectedToDevice()) {
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
  }

  if (Button("Disconnect", (width/2)+10, uiPrevStep(), 320, true)) {

    if (isConnectedToDevice()) {

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
  }

  drawBTConnect(width/2, uiStep(), 12, true);

  uiResetStep(600);

  if (IconButtonRound(iconPower, (width/2)-110, uiStep()-55, 220, 220, false, false)) {
    String m = "$1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (IconButton(iconNext, (width/2)+120, uiPrevStep(), 256, 116, false, true)) {
    String m = "$3;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (IconButton(iconPrev, (width/2)-376, uiPrevStep(), 256, 116, false, true)) {
    String m = "$2;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  uiResetStep(900);

  // ===================================== Brightness =====================================
  int brightnessTemp = int(btBrightness);
  int brightnessTempPrevious = int(btBrightnessPrevious);

  if (IconButtonRound(iconMinus, 100, uiStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btBrightness = constrain(btBrightness - 1, 0, 255);
      String btBrightness = "$5;";
      bt.broadcast(btBrightness.getBytes());
    }
  }

  LabelCenter("Brightness: " + str(int(btBrightness)), 12, (width/2), uiPrevStep());

  if (IconButtonRound(iconPlus, 840, uiPrevStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btBrightness = constrain(btBrightness + 1, 0, 255);
      String btBrightness = "$4;";
      bt.broadcast(btBrightness.getBytes());
    }
  }

  btBrightness = Slider(btBrightness, (width/2)-845/2, uiStep(), 845, s_height);



  // if (brightnessTemp != brightnessTempPrevious) {
  //   String bcString = "$4," + str(brightnessTemp) + ";";
  //   bt.broadcast(bcString.getBytes());

  //   println(bcString);

  //   btBrightnessPrevious = btBrightness;
  //   brightnessTemp = brightnessTempPrevious;
  // }

  // ===================================== Scale =====================================

  uiResetStep(uiStep()+50);

  int scaleTemp = int(btScale);
  int scaleTempPrevious = int(btScalePrevious);

  if (IconButtonRound(iconMinus, 100, uiStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btScale = constrain(btScale - 1, 0, 255);
      String btScale = "$7;";
      bt.broadcast(btScale.getBytes());
    }
  }

  LabelCenter("Scale: " + str(int(btScale)), 12, (width/2), uiPrevStep());

  if (IconButtonRound(iconPlus, 840, uiPrevStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btScale = constrain(btScale + 1, 0, 255);
      String btScale = "$6;";
      bt.broadcast(btScale.getBytes());
    }
  }

  btScale = Slider(btScale, (width/2)-845/2, uiStep(), 845, s_height);

  // if(timeTicker(50))
  // if (scaleTemp > scaleTempPrevious) {
  //   String bcString = "$6";
  //   bt.broadcast(bcString.getBytes());
  //   println(bcString);
  //   btScalePrevious = btScale;
  //   scaleTemp = scaleTempPrevious;
  // }else{
  //       String bcString = "$7";
  //   bt.broadcast(bcString.getBytes());
  //   println(bcString);
  //   btScalePrevious = btScale;
  //   scaleTemp = scaleTempPrevious;
  // }



  // ===================================== Speed =====================================
  uiResetStep(uiStep()+50);

  int speedTemp = int(btSpeed);
  int speedTempPrevious = int(btSpeedPrevious);

  if (IconButtonRound(iconMinus, 100, uiStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btSpeed = constrain(btSpeed - 1, 0, 255);
      String btSpeed = "$9;";
      bt.broadcast(btSpeed.getBytes());
    }
  }

  LabelCenter("Speed: " + str(int(btSpeed)), 12, (width/2), uiPrevStep());

  if (IconButtonRound(iconPlus, 840, uiPrevStep(), 140, 140, false, true)) {
    if (timeTicker(10)) {
      btSpeed = constrain(btSpeed + 1, 0, 255);
      String btSpeed = "$8;";
      bt.broadcast(btSpeed.getBytes());
    }
  }



  btSpeed = Slider(btSpeed, (width/2)-845/2, uiStep(), 845, s_height);

  // if (speedTemp!= speedTempPrevious) {
  //   String bcString = "$6," + str(speedTemp) + ";";
  //   bt.broadcast(bcString.getBytes());
  //   println(bcString);
  //   btSpeedPrevious = btSpeed;
  //   speedTemp = speedTempPrevious;
  // }

  // ===================================== Save =====================================
  if (Button("Save", (width/2)-128, uiStep(), 256, true)) {
    String m = "$10;";
    bt.broadcast(m.getBytes());
    println(m);
  }
}

void cfgTab() {
  int w = width / 2;
  int h = w / 4;
  int y = height - h;

  noStroke();
  fill(c_hover);
  rect(w*1, y-6, w, 4, 2);

  uiResetStep(150);

  LabelCenter("Settings", 25, width/2, uiStep());

  uiResetStep(300);

  LabelBaseWH("Switch theme", 16, 50, uiStep(), 500, 115, LEFT, CENTER);


  if (IconButton(iconTheme, 500, uiPrevStep(), 256, 115, false, true)) {
    if (themeSwitch == 1) {
      themeSwitch = 0;
      file[0] = "0";
      saveStrings("settings.txt", file);
      for (int i = 0; i < file.length; i++) {
        info+=file[i]+"\n";
      }
    } else {
      themeSwitch = 1;
      file[0] = "1";
      saveStrings("settings.txt", file);
      for (int i = 0; i < file.length; i++) {
        info+=file[i]+"\n";
      }
    }
  }

  LabelBaseWH("Auto connect", 16, 50, uiStep(), 500, 115, LEFT, CENTER);

  // autoConnect = Toggle(autoConnect, 500, uiPrevStep(), 256, 115);
  // println(autoConnect);
  // if (autoConnect == true) {
  //   file[1] = "true";
  //   saveStrings("settings.txt", file);
  // } else {
  //   file[1] = "false";
  //   saveStrings("settings.txt", file);
  // }

  if (Toggle(autoConnect, 500, uiPrevStep(), 256, 115)) {
    if (connectedDevice.length() > 0) {
      autoConnect = !autoConnect;
      file[1] = str(autoConnect);
      file[2] = connectedDevice;
      saveStrings("settings.txt", file);
    }
  }
}
