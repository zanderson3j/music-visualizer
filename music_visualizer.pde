//music visualizer

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
FFT         fft;

PImage img;

float vel = 0;
float angle = 0;
float greatest = 0;

float xf1 = 0;
float yf1 = 0;
float xf2 = 0;
float yf2 = 0;

float xp1 = 0;
float yp1 = 0;
float xp2 = 0;
float yp2 = 0;

int specs = 256;

void setup()
{
  size(800, 800, P3D);
  //fullScreen(P3D);
  minim = new Minim(this);


  jingle = minim.loadFile("Awae  Damned - Hold Me (ft. Layna).mp3", specs);
  jingle.loop();

  img = loadImage("237043.jpg");
  tint(91, 255, 101, 126);

  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
}

void draw()
{
  colorMode(RGB, 255, 255, 255);
  background(0);

  fft.forward( jingle.mix );

  float max = 0;
  for(int i = 0; i < fft.specSize(); i++)
  {
    if(max < fft.getBand(i)) {
      max = fft.getBand(i);
    }
  }
  if(greatest < max) {
    greatest = max;
  }

  image(img,0,0, width, height);



  float radius = 300;
  float angleStep = 360.0/(fft.specSize());
  angle = (angle + vel) % 360;
  for(int i = 0; i < fft.specSize()/2; i++) {
     stroke(255);
     strokeWeight(4);
     fill(255);
     float x1 = width/2 + cos(radians(angle)) * (radius - (fft.getBand(i)));
     float y1 = height/2 + sin(radians(angle)) * (radius - (fft.getBand(i)));
     float x2 = width/2 + cos(radians(angle)) * (radius + (fft.getBand(i)));
     float y2 = height/2 + sin(radians(angle)) * (radius + (fft.getBand(i)));
     line(x1, y1, x2, y2);
     ellipse(x1, y1, 3, 3);
     ellipse(x2, y2, 3, 3);
     angle = angle + angleStep;

     if(i == 0) {
       xf1 = x1;
       yf1 = y1;
       xf2 = x2;
       yf2 = y2;
     }
     else if(i == fft.specSize()/2 - 1) {
       line(x1, y1, xp2, yp2);
       line(x2, y2, xp1, yp1);
       fill(123, 123, 123, 70);
       ellipseMode(CORNERS);
       ellipse(x1, y1, xf2, yf2);
       ellipse(x2, y2, xf1, yf1);
       //line(x1, y1, xf2, yf2);
       //line(x2, y2, xf1, yf1);
       ellipseMode(CENTER);
     }
     else {
       line(x1, y1, xp2, yp2);
       line(x2, y2, xp1, yp1);
       xp1 = x1;
       yp1 = y1;
       xp2 = x2;
       yp2 = y2;
     }
  }
  vel = max/70;
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(angle);
  rotateZ(angle);
  noFill();
  stroke(255, 105, 180);
  strokeWeight(1);
  sphere(150);
  popMatrix();
}
