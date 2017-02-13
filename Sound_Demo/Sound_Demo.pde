/* SOUND BASED DEMO */
/* Developed by Ambika Yadav*/
/* MAT 259 : Winter 2017 */

import processing.sound.*;
SinOsc sine_1;

PFont hell;

Table checkouts_2016,checkouts_2015,checkouts_2014;
int final_numRows;
int speed = 5; // less the more

float[] dataMatrix_2014;
float[] dataMatrix_2015;
float[] dataMatrix_2016;
float maxvalue_2016,minvalue_2016,maxvalue_2015,minvalue_2015,maxvalue_2014,minvalue_2014;
int numrows_2016,numrows_2015,numrows_2014;
int x_start_2016,y_start_2016,x_start_2015,y_start_2015,x_start_2014,y_start_2014;


float[] final_dataMatrix;
float final_maxValue ; 
float final_minValue ;
int which_sample = 0;

boolean play = true;

boolean c_2014 = true; 
boolean c_2015 = false;
boolean c_2016 = false;

int dist = 3;
int y_start = 0;
int x_start = 0;


void setup()
{
  
  size(1500,700);
  
  hell = createFont("Helvetica.ttf",32);
  text_on_viz();
  year_2016();
  year_2015();
  year_2014();
  sine_1 = new SinOsc(this);
  sine_1.freq(200);
}

void draw()
{
 
  background(#444444);
  text_on_viz();
  year_2016();
  year_2015();
  year_2014();
  
  if (c_2016)
  {
  final_dataMatrix = dataMatrix_2016;
  final_numRows = numrows_2016;
  final_maxValue = maxvalue_2016; 
  final_minValue = minvalue_2016;
  x_start = x_start_2016; 
  y_start = y_start_2016;
  fill(0,0,0,40);
  stroke(0,0,0,40);
  rect(x_start-20,y_start-50,1100,100);

  }

  if (c_2015)
  {
  final_dataMatrix = dataMatrix_2015;
  final_numRows = numrows_2015;
  final_maxValue = maxvalue_2015; 
  final_minValue = minvalue_2015;
  x_start = x_start_2015; 
  y_start = y_start_2015;
  fill(0,0,0,40);
  stroke(0,0,0,40);
  rect(x_start-20,y_start-50,1100,100);
  }
  
   if (c_2014)
  {
  final_dataMatrix = dataMatrix_2014;
  final_numRows = numrows_2014;
  final_maxValue = maxvalue_2014; 
  final_minValue = minvalue_2014;
  x_start = x_start_2014; 
  y_start = y_start_2014;
  fill(0,0,0,40);
  stroke(0,0,0,40);
  rect(x_start-20,y_start-50,1100,100);
  }
  
  // Amplitude and Frequency Mapping  Of Data
  float[] amplitude = new float[final_numRows];
  float[] frequency = new float[final_numRows];
  for ( int i = 0 ; i < final_numRows; i ++)
  {
    amplitude[i]= map( final_dataMatrix[i],final_minValue,final_maxValue,10,70);
    frequency[i]= map( final_dataMatrix[i],final_minValue,final_maxValue,50,200);
  }
 
  
  if(play == false)
  {
  if(frameCount%speed ==0)
  {
    if (which_sample<final_numRows)
    {
    sine_1.freq(frequency[which_sample]);
    sine_1.amp(amplitude[which_sample]);
    which_sample = which_sample+1;
    }
    else 
    {
     sine_1.stop();
    }
  } 
  fill(255,255,255,20);
  strokeWeight(0); 
  rect(x_start,y_start-75/2,which_sample*dist,75);
  }
  else if(play == true)
  {
  fill(255,255,255,20);
  strokeWeight(0);
  rect(x_start,y_start-75/2,which_sample*dist,75);
  }
  
  
}