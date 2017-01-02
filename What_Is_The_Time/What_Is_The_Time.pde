
import peasy.*;
import processing.opengl.*;

// initialising variables
PeasyCam cam; // camera initialisation
int year=2009; // year count intialisation
Table table1[] ; // all the data is stored in this table array. All the data needed by the code to run.
Table table ;
int rowNums ; // number of rows in the table. ( unique date and time combination)
float radius[]; // radius corresponding to every time( hour)
float endangle; // variable to indicate count, by specifying the length of arc ( endangle)
PFont font;
int opacity[] ={50,50,50,50,50,50,50,50,50,50,50};

//Color of every time 
color c[]={#B76F90,#A084B1,#8794BF,#69A2C4,#4BAFC1,#3ABAB5,#47C3A2,#8BCD74,#B9626A,#9ECE6A,
#AA7DA7,#799BC3,#55C697,#3FB5BC,#BA6A84,#78CB80,#B2769C,#3DBFAC,#D9CC57,#BB6577,#66C98B,#958CB9,#59A9C4,
#B1CE61,#C5CD5B};

// To write text corresponding to time everyday
String time[]={ "0 AM ","1 AM","2 AM","3 AM","4 AM","5 AM","6 AM","7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", 
"1 PM" ,"2 PM", "3 PM", "4 PM", "5 PM", "6 PM","7 PM","8 PM","9 PM", "10 PM","11 PM" };

//Table load paths for data corresponding to every year.
String table_load[]={ "Data_2006.csv","Data_2007.csv","Data_2008.csv","Data_2009.csv","Data_2010.csv","Data_2011.csv",
"Data_2012.csv","Data_2013.csv","Data_2014.csv","Data_2015.csv"};

// For using mouse data to look at visualisations at different point of times . For Example 1 AM every day .
int col_y_s[],col_y_e[];  // start and end position of the mouse in y axis as the x axis is constant at 20.
float mouse_x,mouse_y;   // current position of mousex and mousey without peasy cam consideration.


void setup()
{
  // setting up the peasy cam window
  size(2000,1000, P3D);
  cam = new PeasyCam(this, 700);
  cam.setWheelScale(0.1);
  cam.setDistance(1400);
  
  // initialising arrays.
  table1 = new Table [10];
  col_y_s = new int [23];
  col_y_e = new int [23];
  
  // loading the complete data for all years in a table array 
  for(int i =0;i<10;i++)
 {
   table1[i] = loadTable(table_load[i], "header");
 }
 frameRate(20);
}

void draw()
{
 
 // segregating data in the table into date , time and count.
 ArrayList<Time_Data> data = new ArrayList<Time_Data>(); // declaring the new datatype's array defined in data_read.
 year_and_opacity(); // telling which table had to be assigned to table, according to the year.
 rowNums=table.getRowCount(); // total number of rows
 radius = new float [rowNums]; // radius corresponding to every data point.
 
 int a=0;
 
 //loading the data
 for (int i =0 ; i <rowNums ; i++)
 {
   String date = table.getString(i,0);
   int hour = table.getInt(i,1);
   int count = table.getInt(i,2);
   data.add(new Time_Data(date,hour,count));
 }
 
 //assigning the background
 background(0,0,0);
  
 // characterstics of the center line.
 strokeWeight(3);
 stroke(230,230,230,120);
 line(-20,0,-200,-20,0,20000);
  
 //processing the data 
 for( int i =0; i<rowNums ; i++)
  {
    endangle= map(data.get(i).count,Min(data,rowNums),Max(data,rowNums),0.1*PI,2*PI); //mapping the endangle to the count of every data point
    if(i>0)
     {
    // current and last date
      String str1=data.get(i).date;
      String str2=data.get(i-1).date;
      // evaluating the month by extracting the write characters from the date string
      char month1[] ={str1.charAt(5),str1.charAt(6)};
      String month_1=new String(month1);
      char month2[] ={str2.charAt(5),str2.charAt(6)};
      String month_2=new String(month2);
      
      // if the date of the current and last datapoint are NOT SAME, translate by 15 points in z
      if(str1.equals(str2) == false)
      {
        translate(0,0,15); 
      }
      
      // if the current and last month of the datapoint are not same, draw a low opacity ellipse seperating them.
      if(month_1.equals(month_2) == false)
      {
          hint(DISABLE_DEPTH_TEST);
          fill(230,230,230,10);
          stroke(230,230,230,10);
          ellipse(-20,0,1500,1500);
          hint(ENABLE_DEPTH_TEST);
          a=a+1;
       }
    }
    
    // mapping the radius of every data point to the hour.
    radius[i] = (data.get(i).hour*30)+100;
    
    // start the drawing of the arcs here
    noFill();
    strokeWeight(4);
    stroke(c[data.get(i).hour],200); // color of stroke derived from the set of colors initialised earlier.
    
    
    // if mouse is hovering over the times, represent the number of checkouts corresponding to that.
    if (mouse_x <27 && mouse_x > 13)
    {
      for ( int n =0 ; n< 23 ;n++)
    {
      if (mouse_y < col_y_e[n]-40 && mouse_y >col_y_s[n]-40)
      {
        if (data.get(i).hour == n-1)
        {
          stroke(c[n-1]);
          arc(-40,20, radius[i], radius[i], 0, endangle);
        }
      }
    }
    }
    else 
    {
      stroke(c[data.get(i).hour]);
      arc(-40,20, radius[i], radius[i], 0, endangle);
    }
    
    }
  
  // all the text is driven from here.
  title();  
    
 }