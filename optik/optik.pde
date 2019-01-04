float r, centerX, centerY, xall, w, h;
float offset = 15;
float n = 5;
float angle = 0;
float[] lineCord = new float[4];
float [] refCords = new float[4];
float renderA = PI/2.8;

int openingTime = 10000;
int animationTime = 2500;

String[] buttonStr = {"Merkez Işını", "Odak Işını", "Paralel Işın", "3F Işını", "Çıkış"};

void setup() {
  fullScreen();
  r = height/3;
  centerY = height/2;
  centerX = r;

  xall = width*(0.82);
  w = width*(0.14);
  h = (height*(0.71)-offset*(n-1))/n;

  translate(0, height/2);
  //Başlangıç Doğrusu////////////////////////////////
  for (int i = 0; i<lineCord.length; i++) {
    lineCord[i] = ((i+1)%2)*(200+200*i)+-1*(i%2)*100;
  }

  background(31);
  pushMatrix();
  translate(centerX, centerY);
  noFill();
  ellipse(0, 0, r*2, r*2);
  fill(31);
  stroke(31);
  rect(0, -r, r, 2*r);
  popMatrix();
}

boolean menuMouse() {
  return (mouseX > width*(0.8))& (mouseY > height*(0.03) & (mouseX < width*(0.98))& (mouseY < height*(0.97)));
}

boolean buttonMouse(float xa, float wa, float ya, float ha, boolean press) {
  return ((mouseX >xa && mouseX<xa+wa)&&(mouseY>ya && mouseY<ya+ha)&&(mousePressed||!press));
}


//Signum Fonksiyonu////////////////////////////////
int sgn(float f) {
  if (f>0) return 1;
  if (f<0) return -1;
  return 0;
}

//Kesişim Fonksiyonu//////////////////////////////
float[] interC(float ax, float ay, float bx, float by) {
  float[] res = new float[6];
  ay = - ay;
  by = -by;
  fill(0, 200, 0);
  textSize(20);

  float m = (ay-by)/(ax-bx);
  if (ay-by == 0) {
    float x = -sqrt(pow(r, 2)-pow(ay, 2));
    float mP = -ay/(x+r/2);
    float nP = ay;

    res[0] = x;
    res[1] = -ay;
    res[2] = width;
    res[3] = mP*(width)+nP;
    res[4] = -PI;
    res[5] = 1.0;

    return res;
  }
  float n = ay-m*ax;
  float dx = ax-bx;
  float dy = ay-by;
  float dr = dist(ax, ay, bx, by);


  float detD = ax*by-bx*ay;
  float delta = pow(r*dr, 2)-pow(detD, 2);
  float x = -((detD*dy) + sgn(m)*sgn(dy)*dx*sqrt(delta)) / pow(dr, 2); 
  float y = (-(detD*dx)+ sgn(m)*abs(dy)*sqrt(delta))/(pow(dr, 2));

  //println(x, y);

  float interA = -n/m+r;
  float interB = 1/(2/r - 1/interA) - centerX;

  float mP = y/(x-interB);
  float nP = y-mP*x;

  res[0] = x;
  res[1] = y;
  res[2] = width;
  res[3] = mP*(width)+nP;
  res[4] = interA/(r/2);
  res[5] = interB/(r/2)+2;


  return res;
}

void draw() {
  background(31);
  
  //AYNA VE IŞIN///////////////////////////////////

  pushMatrix();
  strokeWeight(5);
  stroke(#3163C4);
  translate(centerX, centerY);
  noFill();
  arc(0, 0, r*2, r*2, PI-renderA, PI+renderA);
  //ellipse(0, 0, r*2, r*2);
  //fill(31);
  //stroke(31);
  //rect(0, r, r, -2*r);
  stroke(200);
  line(lineCord[0], lineCord[1], lineCord[2], lineCord[3]);  
  float[] c = interC(lineCord[0], lineCord[1], lineCord[2], lineCord[3]);
  line(lineCord[2], lineCord[3], c[0], c[1]);
  stroke(0, 0, 200);
  line(c[0], c[1], c[2], c[3]);
  stroke(200, 0, 0);
  point(c[0], c[1]);
  popMatrix();

  //ASAL EKSEN/////////////////////////////////////

  stroke(0, 200, 0);
  strokeWeight(2);
  line(0, height/2, width, height/2);
  strokeWeight(5);
  stroke(200, 0, 0);
  fill(200, 0, 0);

  //MENU RENDER////////////////////////////////////

  point(centerX, centerY);
  text("M 'Merkez'", centerX-10, centerY -10);

  point(centerX/2, centerY);
  text("F 'Odak' ", centerX/2-10, centerY -10);

  fill(#3163C4);
  text("Çukur Ayna", centerX - r+50, centerY - r+10);

  textSize(16);

  stroke(50);
  fill(200);
  rect(width*(0.8), height*(0.03), width*(0.18), height*(0.94), 10);

  fill(0);
  String temp = "";
  temp = (c[4] == -PI)?"Paralel":str(c[4])+" F";
  text("Gelen ışın: "+temp, width*(0.82), height*(0.09));
  text("Giden ışın: "+str(c[5])+" F", width*(0.82), height*(0.15));

  //BUTTON RENDER/////////////////////////////////
  //rect(width*(0.82), height*(0.20),width*(0.14),height*(0.71));

  for (int i = 0; i<n; i++) {
    float y1 = height*(0.20) +i*(offset + h); 
    fill(150);
    if (buttonMouse(xall, w, y1, h, true)) {
      fill(175);
    }
    rect(xall, y1, w, h, 10);
    textAlign(CENTER);
    textSize(20);
    fill(0);
    text(buttonStr[i], xall+w/2, y1+h/2);
  }

  if(millis() < openingTime){
    fill(31,map(-millis()+openingTime-animationTime,0,animationTime,0,255));
    rect(-50,-50,width+100,height+100);
    fill(200,map(-millis()+openingTime-animationTime,0,animationTime,0,255));
    textSize(50);
    text("OPTİK SİMULASYONU",width/2,height*(0.4));
    textSize(20);
    text("Tuncer Demir için özel olarak yapılmıştır.",width/2,height*(0.5));
    textSize(10);
    text("Cafer SELLİ",width-50,height-20);
    noFill();
    stroke(200,map(-millis()+openingTime-animationTime,0,animationTime,0,20));
    arc(width/2,height*(0.8),80,80,0,TWO_PI);
    stroke(200,map(-millis()+openingTime-animationTime,0,animationTime,0,255));
    arc(width/2,height*(0.8),80,80,-PI/6-angle,PI/6-angle);
  }
  textAlign(TOP);
  angle+=0.1;
}
void mousePressed() {
  if (!menuMouse()) {
    if (mouseButton == LEFT) {
      lineCord[0] = mouseX-centerX;
      lineCord[1] = mouseY-centerY;
    } else if (mouseButton == RIGHT) {
      lineCord[2] = mouseX-centerX;
      lineCord[3] = mouseY-centerY;
    }
  }
}
void mouseReleased() {

  float[] expMer = {0, 0, r, r/2};

  float[] expOdk = {-r/2, 0, r, r};

  float[] expPar = {r, r/2, r*2.0, r/2};

  float[] exp3F  = {r/2, 0, 2*r, -r/2};


  for (int i = 0; i<n; i++) {
    float y1 = height*(0.20) +i*(offset + h);
    if (buttonMouse(xall, w, y1, h, false))
    {
      if (i == 0) {
        lineCord = expMer;
      } else if (i == 1) {
        lineCord = expOdk;
      } else if (i == 2) {
        lineCord = expPar;
      } else if (i == 3) {
        lineCord = exp3F;
      } else if (i == 4) {
        exit();
      }
    }
  }
}
