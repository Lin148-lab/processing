int pointsNum=100;          //832503119 ShiYichen
float[][] points=new float[pointsNum][13];
int pointCount=0;

int foodNum=int(random(10,20));
float[][] food=new float[foodNum][8];
int foodCount=0;

float wd,hd,dd;

void setup(){
size(900,600);
background(255);
noStroke();
}

void draw(){
fill(255);
rect(0,0,width,height);
 for(int i=0;i<pointCount;i++){
 drawPoint(i);
 update(i);
 }
 
 for(int i=0;i<pointCount;i++){
    for(int j=0;j<i;j++){
    if((points[i][0]-points[j][0])*(points[i][0]-points[j][0])+(points[i][1]-points[j][1])*(points[i][1]-points[j][1])<(points[i][4]/2+points[j][4]/2)*(points[i][4]/2+points[j][4]/2)){   
      points[pointCount][0]=(points[i][0]+points[j][0])/2;               //xy
      points[pointCount][1]=points[i][1]+30; 
      points[pointCount][11]=500;
      if(random(1)>0.5){                                //speed
      points[pointCount][2]=points[i][2];
      points[pointCount][3]=points[i][3];
      }else{
      points[pointCount][2]=points[j][2];
      points[pointCount][3]=points[j][3];
      }     
      if(random(1)>0.5){
      points[pointCount][4]=points[i][4];                  //d
      }else{
      points[pointCount][4]=points[j][4];
      }
      if(random(1)>0.5){
      points[pointCount][5]=points[i][5];                  //color
      points[pointCount][6]=points[i][6];
      points[pointCount][7]=points[i][7];
      }else{
      points[pointCount][5]=points[j][5];
      points[pointCount][6]=points[j][6];
      points[pointCount][7]=points[j][7];
      }
      if(random(1)>0.5){                        //hand
      points[pointCount][8]=points[i][8];
      }else{
      points[pointCount][8]=points[j][8];
      }
      if(random(1)>0.5){                           //leg
      points[pointCount][9]=points[i][9];
      }else{
      points[pointCount][9]=points[j][9];
      }
      if(random(1)>0.2){
      points[pointCount][10]=0;                  //wid
      }else{
      points[pointCount][10]=points[pointCount][4];
      }
      if(random(1)>0.5){                        //ds
      points[pointCount][12]=points[i][12];
      }else{
      points[pointCount][12]=points[j][12];
      }
      
      points[i][0]=-(i+50);
      points[j][0]=-(j+50);
      points[i][1]=-(i+50);
      points[j][1]=-(j+50);
      points[i][2]=0;
      points[j][2]=0;
      points[i][3]=0;
      points[j][3]=0;
      points[i][4]=0;
      points[j][4]=0;
      points[i][8]=0;
      points[j][8]=0;
      points[i][9]=0;
      points[j][9]=0;
      points[i][10]=0;
      points[j][10]=0;
      pointCount++;     
    }     
    }
 }
  
  for(int i=0;i<pointCount;i++){              //people die
    if(points[i][11]<=0){
      points[i][0]=-(i+50);
      points[i][1]=-(i+50);
      points[i][2]=0;
      points[i][3]=0;
      points[i][4]=0;
      points[i][8]=0;
      points[i][9]=0;
      points[i][10]=0;
    }
  }
  
     for(int i=0;i<foodNum;i++){                           //create food
     fill(#5BF567);
     circle(food[i][0],food[i][1],food[i][2]);
    }
  
  for(int i=0;i<pointCount;i++){
    for(int j=0;j<foodNum;j++){
      if((points[i][0]-food[j][0])*(points[i][0]-food[j][0])+(points[i][1]-food[j][1])*(points[i][1]-food[j][1])<(points[i][4]/2+food[j][2]/2)*(points[i][4]/2+food[j][2]/2)){ 
      points[i][11]+=50;                              //food can add lives
      food[j][0]=-5;
      food[j][1]=-5;
      food[j][2]=0;
      }     
    }   
  }
  
      fill(0);
      circle(wd,hd,dd);                        //create poison
  for(int i=0;i<pointCount;i++){
    if((points[i][0]-wd)*(points[i][0]-wd)+(points[i][1]-hd)*(points[i][1]-hd)<(points[i][4]/2+dd/2)*(points[i][4]/2+dd/2)){
    wd=width+50;
    hd=height+50;
    dd=0;
    points[i][11]=0;                         //people die
    }
    
     if((points[i][0]-wd)*(points[i][0]-wd)+(points[i][1]-hd)*(points[i][1]-hd)<(points[i][12]/2+dd/2+100)*(points[i][12]/2+dd/2+100)){  //a simple selection way   
       if(points[i][0]-wd<0&&points[i][2]<0){points[i][2]=-points[i][2];}                                   //people will close to poison in a range
       if(points[i][0]-wd>0&&points[i][2]>0){points[i][2]=-points[i][2];}
       if(points[i][1]-hd<0&&points[i][3]<0){points[i][3]=-points[i][3];}
       if(points[i][1]-hd>0&&points[i][3]>0){points[i][3]=-points[i][3];}
     }     
  } 
}

void keyPressed(){                                    //operation
if (key == 'q'|| key == 'Q') {  
     for(int i=0;i<foodNum;i++){
     foodPoint(i);
    }    
  }
  if (key == 'e'|| key == 'E') {  
     dd=20;
     wd=random(20,880);
     hd=random(20,580);
  }
}

void foodPoint(int foodCount){
if(foodCount<foodNum){
    food[foodCount][0]=random(20,880);//x1
    food[foodCount][1]=random(20,580);//y1
    food[foodCount][2]=random(5,20);//d1
    //food[foodCount][3]   
  }
}


void mousePressed(){
  creatPoints(mouseX,mouseY);
}

void creatPoints(float x,float y){
if(pointCount<pointsNum){
    points[pointCount][0]=x;//x
    points[pointCount][1]=y;//x
    points[pointCount][2]=random(-3,3);//xspeed
    points[pointCount][3]=random(-3,3);//yspeed
    points[pointCount][4]=random(15,30);//d
    points[pointCount][5]=random(255);//r
    points[pointCount][6]=random(255);//g
    points[pointCount][7]=random(255);//b
    points[pointCount][8]=points[pointCount][4];//d-hand
    points[pointCount][9]=points[pointCount][4];//d-leg
    points[pointCount][10]=0;//wid
    points[pointCount][11]=500;//lives
    points[pointCount][12]=random(20,50);//d-search
    pointCount++;
  }
}

void drawPoint(int count){
float x=points[count][0];
float y=points[count][1];
float xSpeed=points[count][2];
float ySpeed=points[count][3];
float d=points[count][4];
float r=points[count][5];
float g=points[count][6];
float b=points[count][7];
float dh=points[count][8];
float dl=points[count][9];
float w=points[count][10];
float lives=points[count][11];
float ds=points[count][12];
fill(r,g,b);
noStroke();
circle(x,y,d);//head
rect(x-dh,y+d/2,2*dh,dh/3);//hand
rect(x-d/4,y,d/2,2*d);//body
ellipse(x,y+d,w,2*d);
textSize(20);
text(lives,x,y-d);//show live
quad(x-d/4,y+7*d/4,x,y+2*d,x-3*dl/4,y+11*dl/4,x-dl,y+10*dl/4);//leg
quad(x,y+2*d,x+d/4,y+7*d/4,x+dl,y+10*dl/4,x+3*dl/4,y+11*dl/4);
}

void update(int count){
points[count][0]+=points[count][2];
points[count][1]+=points[count][3];
points[count][11]-=1;//lives lose
if(points[count][0]>width) points[count][0]=0;
if(points[count][0]<0&&points[count][0]>-10) points[count][0]=width;
if(points[count][1]>height) points[count][1]=0;
if(points[count][1]<0&&points[count][1]>-10) points[count][1]=height;
}
