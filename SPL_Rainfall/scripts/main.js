
// 2D matrix table related variables
var table_1,table_2; // to read the csv file
var dataMatrix_1,dataMatrix_2 ;
var change_year_index,change_year_width;

var numRows ; //number of rows and cols in the table
var dataMatrix ;

var maxtempValue, mintempValue,max_CheckOuts,min_CheckOuts,maxprepValue,minprepValue; //max and min values to plot
var start_angle,end_angle;

var c,c_center;
var grid_prep,grid_checkout;
var switch_compare=true;
var colorPath,colorBar_checkouts,colorBar_prep;


function preload()
{
	table_1 = loadTable("data/weather_temp_comparingcheckouts.csv", "header");
	table_2 = loadTable("data/weather_prep_comparingcheckouts.csv", "header");

	colorPath = ["data/Grid_Checkouts1.jpg","data/Prep_Temp_Grid.jpg"];
   	colorBar_checkouts = loadImage(colorPath[0]);
    colorBar_prep = loadImage(colorPath[1]);

    grid_prep=loadImage("data/Prep_Temp_Grid.jpg");
    grid_checkout=loadImage("data/Grid_Checkouts1.jpg");
}

function setup()
{
  canvas = createCanvas(window.innerWidth, window.innerHeight);    
  numRows = table_1.getRowCount();

  // Variables for temperature checkouts 
  dataMatrix_1 = load_datamatrix(table_1);
  maxtempValue = max2D(dataMatrix_1,2,numRows);
  mintempValue = min2D(dataMatrix_1,2,numRows);
  angles_temp = defining_angles(dataMatrix_1,maxtempValue,mintempValue,numRows);

  // Variables for precipitation checkouts
  dataMatrix_2 = load_datamatrix(table_2); 
  maxprepValue = max2D(dataMatrix_2,2,numRows);
  minprepValue = min2D(dataMatrix_2,2,numRows);
  angles_prep = defining_angles(dataMatrix_2,maxprepValue,minprepValue,numRows);

  // Mututal Variables 
  max_CheckOuts = max2D(dataMatrix_1,1,numRows);
  min_CheckOuts = min2D(dataMatrix_1,1,numRows);

 var change_year_parameters = predraw_year_segregator(numRows,dataMatrix_1);
 change_year_index = change_year_parameters.change_year_index;
 change_year_width = change_year_parameters.change_year_width;
 
}

function draw() 
{
  background(50,50,50); 
  
  c = new Array();
  c_center = new Array();

  var x_c=window.innerHeight/2 + 50;
  var y_c=window.innerHeight/2;
  var margin = 60 ; 
  var starting_position = 100;

  var angle ;

  if(switch_compare == true)
  {
  dataMatrix = dataMatrix_1;
  angle = angles_temp;
  start_angle = angle.start_angle;
  end_angle = angle.end_angle;
  start_angle[1243]=(19*PI)/10;
  end_angle[1243]=(20*PI)/10;
  }
  else if(switch_compare == false)
  {
  dataMatrix = dataMatrix_2;
  angle = angles_prep;
  start_angle = angle.start_angle;
  end_angle = angle.end_angle;
  start_angle[644]=(19*PI)/10;
  end_angle[644]=(20*PI)/10;
  }

   // Color Allocation every small arc indicating checkouts number (multi color)
    for (var j=0; j<numRows; j++) 
    { 
    c[j] = colorBar_checkouts.get(map(dataMatrix[j][1], min_CheckOuts, max_CheckOuts,2,colorBar_checkouts.width-2),colorBar_checkouts.height/2);
    }
   // Color Allocation for big filled arc indicating precipitation (blue color)
    for (var j=0; j<21; j++) 
    {
    c_center[j] = colorBar_prep.get(map(j,0,20,15,colorBar_checkouts.width),colorBar_checkouts.height/2);
    }

  // SHADING index the precipitation areas
  for (var i =0 ;i<20;i++)
  {
    fill(c_center[i],250);
    noStroke();
    arc(x_c,y_c,window.innerHeight,window.innerHeight,i*(PI/10),(i+1)*(PI/10));
  } 
   
  // Drawing lines along to index the precipitation areas
  var l = window.innerHeight/2 ;
  for (var i=0;i<10;i++)
  {
    var m = tan(i*PI/10);
    var x_l= x_c+sqrt((l*l)/((m*m)+1));
    var y_l= y_c+m*(sqrt((l*l)/((m*m)+1)));
    var x_l1= x_c-sqrt((l*l)/((m*m)+1));
    var y_l1= y_c-m*(sqrt((l*l)/((m*m)+1)));
    stroke(0,0,0,50);
    noFill();
    strokeWeight(1);
    line(x_c,y_c,x_l,y_l);   
    line(x_c,y_c,x_l1,y_l1); 
  }

  // Year segregators 
	draw_year_segregator(change_year_index,change_year_width,numRows,starting_position,margin,x_c,y_c);

  // Checkout Arcs
  for (var i =0 ;i<numRows;i++)
  { 
    var test = map(1,0,numRows,0,window.innerHeight-(100+margin));
    var r = i*test+starting_position;
    noFill();
    stroke(c[i]);
    strokeWeight(1.2);
    arc(x_c,y_c,r,r,start_angle[i],end_angle[i]);
    
  }
  
  // TEXT INDEX

   //YEARS
   textSize(10.5);
   fill(50,50,50);
   strokeWeight(0);
   var year_number = 2006 ; 
   for ( var year_id = 1; year_id < change_year_index.length-1 ; year_id++)
   {
   	 var position = map(change_year_index[year_id],0,numRows,0,(window.innerHeight-160)/2);
   	 var width = map(change_year_width[year_id],0,numRows,0,(window.innerHeight-160)/2);
   	 text(str(year_number),x_c+position+width/2,y_c);
   	 year_number+= 1; 
   }
   
   text("2015", x_c+(window.innerHeight)/2- 27, y_c); 
   
  // //SIDE COMMENTRY
  textSize(60);
  fill(250,250,250);
  text("IS THE SUN OUT",window.innerWidth- 570,y_c-100);
    
  textSize(12);
  fill(200,200,200);
  textLeading(13);
  text("| Visualizing Seattle Public Library Checkouts dependency on temperature and rainfall \nlevels in Seattle on a daily basis from 2006-2015 |",window.innerWidth- 567,y_c-45 );
  
  
  textSize(10);
  fill(200,200,200);
  textLeading(12);
  if(switch_compare == true)
  text("Every day from 1st January 2006 to 22 January 2015 is depicted by an arc constricted in a angle \nwhich depicts the temperature in Seattle on that particular the day. The number of checkouts \ncolor coded where black indicates the minimum checkouts.",window.innerWidth- 567,y_c-15);
  else if(switch_compare == false)
  text("Every day from 1st January 2006 to 22 January 2015 is depicted by an arc constricted in a angle \nwhich depicts the rainfall in Seattle on that particular the day. The number of checkouts \ncolor coded where black indicates the minimum checkouts.",window.innerWidth- 567,y_c-15 );
  
  // GRIDS
  // Checkouts
  textSize(12);
  fill(200,200,200);
  text("NUMBER OF CHECKOUTS",window.innerWidth- 567, y_c+30);
  
  image(colorBar_checkouts, window.innerWidth- 567, y_c+35, window.innerWidth/3.5, height/75);
  
  textSize(12);
  fill(200,200,200);
  if(switch_compare == true)
  text("TEMPERATURE",window.innerWidth- 567,y_c+65);
  else if(switch_compare == false)
  text("RAINFALL",window.innerWidth- 567,y_c+65);
  
  // Temp/Prep
  image(grid_prep, window.innerWidth- 567, y_c+70, window.innerWidth/3.5, height/75);
  textSize(10);
  fill(200,200,200);

  textSize(13);
  fill(100,100,100);
  text("| PRESS SPACE TO SWITCH BETWEEN TEMPERATURE AND PRECIPITATION |",window.innerWidth- 567,window.innerHeight- 30);

}

function keyPressed() {
  if(keyCode == 32)
  {
    if (switch_compare == false)
    {
    console.log("Key Pressed");  
    switch_compare= true;
    }
    else if (switch_compare== true)
    {
    console.log("Key Pressed");
    switch_compare= false;
    }
  }
}