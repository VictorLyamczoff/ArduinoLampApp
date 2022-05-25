color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color white = color(255, 255, 255);
color black = color(0, 0, 0);

byte curTab = 0;

boolean themeSwitch = true;

Toggle switchTheme = new Toggle();

String btStatus = "";

void tabs() {
  uiFill();

  uiSetScale(uiScale);

  int w = width / 2;
  int h = w / 4;
  int y = height - h;

  if (Button("eff", 0, y, w, h, false)) {
    curTab = 0;
  }

  if (Button("cfg", w*1, y, w, h, false)) {
    curTab = 1;
  }

  if (curTab == 0) effTab();
  if (curTab == 1) cfgTab();

  if (themeSwitch) {
    uiDark();
  } else {
    uiLight();
  }
}

void drawBTConnect(int pos_x, int pos_y, int size, boolean center) {

  if (bt.getConnectedDeviceNames().isEmpty()) {
    fill(red);
    textSize(int(size*_ui_scale));
    if (center) textAlign(CENTER, CENTER);
    else textAlign(LEFT, CENTER);
    text("Status: Not connected", pos_x, pos_y+10);
  } else {
    btStatus="";
    ArrayList<String> devices = bt.getConnectedDeviceNames();  // 20
    for (String device : devices)
    {
      btStatus = "Connect to "+device;
    }
    fill(green);
    textSize(int(size*_ui_scale));
    if (center) textAlign(CENTER, CENTER);
    else textAlign(LEFT, CENTER);
    text("Status: "+btStatus, pos_x, pos_y+10);
  }
}

void effTab() {

  LabelCenter("ArduinoLamp", 18, (width/2), 86);

  uiResetStep(300);

  if (Button("Connect", (width/2)-330, uiStep(), 320, true)) {

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

  if (Button("Disconnect", (width/2)+10, uiPrevStep(), 320, true)) {

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

  drawBTConnect(width/2, uiStep(), 12, true);

  uiResetStep(600);

  if (Button("I/O", (width/2)-110, uiStep()-55, 220, 220, true)) {
    String m = "$1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button(">>", (width/2)+120, uiPrevStep(), 256, true)) {
    String m = "$2,1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button("<<", (width/2)-376, uiPrevStep(), 256, true)) {
    String m = "$2,0;";
    bt.broadcast(m.getBytes());
    println(m);
  }


  uiResetStep(900);

  // ===================================== Brightness =====================================
  int brightnessTemp = int(btBrightness);
  int brightnessTempPrevious = int(btBrightnessPrevious);

  if (Button("-", 100, uiStep(), 140, 140, true)) {
    if (btBrightness > 0) {
      btBrightness -= 1.0;
    }
  }

  LabelCenter("Brightness: " + str(int(btBrightness)), 12, (width/2), uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140, true)) {
    if (btBrightness <= 255) {
      btBrightness += 1.0;
    }
  }

  btBrightness = Slider(btBrightness, (width/2)-845/2, uiStep(), 845, s_height);



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

  if (Button("-", 100, uiStep(), 140, 140, true)) {
    if (btScale > 0) {
      btScale -= 1.0;
    }
  }

  LabelCenter("Scale: " + str(int(btScale)), 12, (width/2), uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140, true)) {
    if (btScale <= 255) {
      btScale += 1.0;
    }
  }


  btScale = Slider(btScale, (width/2)-845/2, uiStep(), 845, s_height);

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

  if (Button("-", 100, uiStep(), 140, 140, true)) {
    if (btSpeed > 0) {
      btSpeed -= 1.0;
    }
  }

  LabelCenter("Speed: " + str(int(btSpeed)), 12, (width/2), uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140, true)) {
    if (btSpeed <= 255) {
      btSpeed += 1.0;
    }
  }



  btSpeed = Slider(btSpeed, (width/2)-845/2, uiStep(), 845, s_height);

  if (speedTemp!= speedTempPrevious) {
    String bcString = "$6," + str(speedTemp) + ";";
    bt.broadcast(bcString.getBytes());
    println(bcString);
    btSpeedPrevious = btSpeed;
    speedTemp = speedTempPrevious;
  }

  // ===================================== Save =====================================
  if (Button("Save", (width/2)-128, uiStep(), 256, true)) {
    String m = "$3;";
    bt.broadcast(m.getBytes());
    println(m);
  }
}

void cfgTab() {
  // if(switchTheme.show(200, 200, 80, 50).getSelected()) {
  //     themeSwitch = false;
  // }else{
  //     themeSwitch = true;
  // }
  LabelCenter("Settings", 16, width/2, 20);

  uiResetStep(200);

  Label(info, 10, width/2, 20);

  // themeSwitch = Toggle("Dark theme",themeSwitch, 50, uiStep(), (int)textWidth("Dark theme"), 100);
}
