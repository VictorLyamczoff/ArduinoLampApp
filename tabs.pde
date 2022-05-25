byte curTab = 0;

boolean themeSwitch = true;

Toggle switchTheme = new Toggle();

void tabs() {
  uiFill();

  uiSetScale(uiScale);

  int w = width / 2;
  int h = w / 4;
  int y = height - h;

  if (Button("eff", 0, y, w, h)) {
    curTab = 0;
  }

  if (Button("cfg", w*1, y, w, h)) {
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

void effTab() {
  // uiLight();

  //   beginCard(0, 0, width, height);

  LabelCenter("ArduinoLamp", 16, (width/2), 86);

  uiResetStep(300);

  // if (bt.getConnectedDeviceNames().isEmpty()) {
  //   push();
  //   fill(255, 0, 0);
  //   rect(400+s_med/2+50, card_y+100, 20, 20);
  //   pop();
  // } else {
  //   push();
  //   fill(0, 255, 0);
  //   rect(400+s_med/2+50, card_y+100, 20, 20);
  //   String info="";
  //   ArrayList<String> devices = bt.getConnectedDeviceNames();  // 20
  //   for (String device : devices)
  //   {
  //     info+= device+"\n";
  //   }
  //   text(info, 400+s_med/2+80, card_y+120);
  //   pop();
  // }

  if (Button("Connect", (width/2)-330, uiStep(), 320)) {

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

  if (Button("Disconnect", (width/2)+10, uiPrevStep(), 320)) {

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

  if (Button("I/O", (width/2)-110, uiStep()-(110/2), 220, 220)) {
    String m = "$1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button(">>", (width/2)+120, uiPrevStep(), 256)) {
    String m = "$2,1;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  if (Button("<<", (width/2)-376, uiPrevStep(), 256)) {
    String m = "$2,0;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  // uiTextSize(int(6*3.5));

  uiResetStep(1010);

  // ===================================== Brightness =====================================
  int brightnessTemp = int(btBrightness);
  int brightnessTempPrevious = int(btBrightnessPrevious);

  if (Button("-", 100, uiStep(), 140, 140)) {
    if (btBrightness > 0) {
      btBrightness -= 1.0;
    }
  }

  LabelCenter("Brightness: " + str(int(btBrightness)), 12, (width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, 800, uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140)) {
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

  if (Button("-", 100, uiStep(), 140, 140)) {
    if (btScale > 0) {
      btScale -= 1.0;
    }
  }

  LabelCenter("Scale: " + str(int(btScale)), 12, (width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, 800, uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140)) {
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

  if (Button("-", 100, uiStep(), 140, 140)) {
    if (btSpeed > 0) {
      btSpeed -= 1.0;
    }
  }

  LabelCenter("Speed: " + str(int(btSpeed)), 12, (width/2), uiPrevStep());
  // LabelCenter(str(int(btBrightness)), 12, 800, uiPrevStep());

  if (Button("+", 840, uiPrevStep(), 140, 140)) {
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
  if (Button("Save", (width/2)-128, uiStep(), 256)) {
    String m = "$3;";
    bt.broadcast(m.getBytes());
    println(m);
  }

  //   endCard();
}

void cfgTab() {
    // if(switchTheme.show(200, 200, 80, 50).getSelected()) {
    //     themeSwitch = false;
    // }else{
    //     themeSwitch = true;
    // }
    LabelCenter("Settings", 16, width/2, 20);
    
    uiResetStep(200);
    
    // themeSwitch = Toggle("Dark theme",themeSwitch, 50, uiStep(), (int)textWidth("Dark theme"), 100);
}
