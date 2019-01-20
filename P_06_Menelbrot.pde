double scale=1;
double mX=0;
double mY=0;
int max=400;
float s=1;  //current value of display simplification (1 or sMax)
float sMax=2;  //simplification if it is ON
float col=0.25;
boolean text=true;
void setup()
{
  colorMode(HSB,255);
  fullScreen();
  //size(600,600);
  frameRate(60);
  paint();
}

void mouseWheel(MouseEvent event) {
   scale+=event.getCount()*scale*0.4;
  println("Scale: " + scale);
  paint();
}

void keyPressed()
{
  println(keyCode);
  switch(keyCode)
  {
    case 38: max/=0.1; break; //v
    case 40: max*=0.1; break; //^
    case 37: max+=10; break; //<--
    case 39: max-=10; break; //-->
    case 109: if(sMax>2)sMax-=1; if(s>1) s=sMax; break;  //-
    case 107: sMax+=1; if(s>1) s=sMax; break;  //+=
    case 91: col-=0.025; break; //]
    case 93: col+=0.025; break; //[
    case 10: saveFrame(); break; //ENTER
    case 84: text=!text; break; //t
    case 32: if(s==1) s=sMax; else s=1; break; //SPACE
  }
  paint ();
}

void draw()
{
  if(mouseButton==LEFT && (mouseX-pmouseX!=0 ||mouseY-pmouseY!=0))
  {
    mX-=(mouseX-pmouseX)*scale*0.01;
    mY-=(mouseY-pmouseY)*scale*0.01;
    println(mouseX-pmouseX);
    paint();
  }
}


void paint()
{
  noStroke();
  //scale(s);
  background(0);
  //scale(scale);
for(int x=0;x<width/s;x++)
  for(int y=0;y<height/s;y++)
  {
    //float a=map(x,0,width,-2/scale,2/scale);
    //float b=map(y,0,height,-2/scale,2/scale);
    double a=mapD(x,0,height/s,-2*scale+mX,2*scale+mX);
    double b=mapD(y,0,height/s,-2*scale+mY,2*scale+mY);
    
    int n;
    double a1=a;
    double b1=b;
    for(n=0;n<max;n++)
    {
      double a2 = a*a-b*b;
      double b2 = 2*a*b;
      a=a2+a1;
      b=b2+b1;
      
      if(n==max/4)
        if(a*a+b*b<0.5)
          {
            n=max;
            break;
          }
    
      if(a*a+b*b>16) break;
    }
    
    /*if(n==50)
    c[x][y]=255;
    else
    c[x][y]=0;*/
    float bri = map(n,0,max,0,1);
    if(n==max)
    fill(0);
    else
    fill(map(pow(bri,col),0,1,120,255),255,255);
    rect(x*s,y*s,1,1);
  }
  
  if(text) write();
}

void write()
{
  fill(255);
  textSize(12);
  String txt= "Zoom * " + 1/scale;
  txt+= "\nRendering = " + max;
  txt+= "\nColor = " + col;
  txt+= "\nPreview = " + s + "/" + sMax;
  text(txt,10,15);
}


double mapD(int in, float a1, float b1, double a2, double b2)
{
  double map=(in-a1)/(b1-a1)*(b2-a2);
  map+=a2;
  return map;
}
