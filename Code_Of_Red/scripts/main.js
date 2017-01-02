var img;

var war_data;
var war_data_rowNums;


var art_data;
var art_data_rowNums;

var text_font ; // font1 

// Adding data Points in the table
var year_index = new Array(); // actual year of war -1900
var art_year = new Array(); //actual year of art - 1900
var count_year = new Array(); // index of artwork in the one year
var total_count = new Array(); // number of artwork in that one year.

// VARIABLES FOR ELLIPSE REPRESENTING YEARS 
var a = 40; // distance between ellipse in the ZOOM AREA
var b = 4.5;  // distance between ellipse in NON ZOOM AREA
var x = 5*window.innerWidth/7; // center of ellipse
var y = window.innerHeight/2;  // center of ellipse

var key_press = 0 ;

var artwork_tables = new Array();
var war_tables = new Array();


function preload()
{
  // Background Image Loading
  img = loadImage("Data_Json/2_back2.jpg");  
  text_font = loadFont("Data_Json/helvetica.ttf");
}  

function setup()
{
  var canvas = createCanvas(window.innerWidth, window.innerHeight);
}

function draw ()
{
  //BACKGROUND
  background (0,0,0);
  image(img,0,0);
  noFill();

  
  var wars = new Array();
  var arts = new Array();
  var country_name; ; 

 //********************** DATA LOADING HERE ***************************//
 // WAR DATA LOAD
  switch (key_press)
  {
     case 0 : 
     {
      wars = Worldwide_War;
      arts = Worldwide_Artwork;
      country_name = "WORLDWIDE";
     }
     break;
    case 1 : 
     {
      wars = America_War;
      arts = America_Artwork;
      country_name = "AMERICA";
     }
     break;
    case 2:
     {
      wars = Australia_War;
      arts = Australia_Artwork;
      country_name = "AUSTRALIA";
     }
      break;
    case 3 : 
     {
      wars = Austria_War;
      arts = Austria_Artwork;
      country_name = "AUSTRIA";
     }
     break;
    case 4 : 
     {
      wars = Brazil_War;
      arts = Brazil_Artwork;
      country_name = "BRAZIL";
     }
     break;
    case 5:
     {
      wars = Britain_War;
      arts = Britain_Artwork;
      country_name = "BRITAIN";
     }
      break;
    case 6 : 
     {
      wars = Canada_War;
      arts = Canada_Artwork;
      country_name = "CANADA";
     }
     break;
    case 7 : 
     {
      wars = France_War;
      arts = France_Artwork;
      country_name = "FRANCE";
     }
     break;
    case 8:
     {
      wars = Germany_War;
      arts = Germany_Artwork;
      country_name = "GERMANY";
     }
      break;
    case 9 : 
     {
      wars = Greece_War;
      arts = Greece_Artwork;
      country_name = "GREECE";
     }
     break;
    case 10 : 
     {
      wars = Hungary_War;
      arts = Hungary_Artwork;
      country_name = "HUNGARY";
     }
     break;
    case 11:
     {
      wars = Israel_War;
      arts = Israel_Artwork;
      country_name = "ISRAEL";
     }
      break;
    case 12:
     {
      wars = Italy_War;
      arts = Italy_Artwork;
      country_name = "ITALY";
     }
      break;
    case 13 : 
     {
      wars = Japan_War;
      arts = Japan_Artwork;
      country_name = "JAPAN";
     }
     break;
    case 14 : 
     {
      wars = Mexico_War;
      arts = Mexico_Artwork;
      country_name = "MEXICO";
     }
     break;
    case 15:
     {
      wars = Netherland_War;
      arts = Netherland_Artwork;
      country_name = "NETHERLAND";
     }
      break;
    case 16 : 
     {
      wars = Poland_War;
      arts = Poland_Artwork;
      country_name = "POLAND";
     }
     break;
    case 17 : 
     {
      wars = Romania_War;
      arts = Romania_Artwork;
      country_name = "ROMANIA";
     }
     break;
    case 18:
     {
      wars = Russia_War;
      arts = Russia_Artwork;
      country_name = "RUSSIA";
     }
      break;
    case 19:
     {
      wars = Spain_War;
      arts = Spain_Artwork;
      country_name = "SPAIN";
     }
      break;
    case 20 : 
     {
      wars = Switzerland_War;
      arts = Switzerland_Artwork;
      country_name = "SWITZERLAND";
     }
     break;
    case 21 : 
     {
      wars = Ukrain_War;
      arts = Ukarin_Artwork;
      country_name = "UKRAIN";
     }
     break;
  }

  var which_country = country_interaction(country_name);
  count_year = new Array();
  total_count = new Array();
  art_year_count(arts);
  
  //********** WAR AREA HIGHLIGHTING ********??
  // USING MOUSE POSITIONS TO ZOOM INTO DIFFERENT 10 YEAR ZONES (try converting to a side scroll)
  var m = zoom_year_slider();
  war_name_display(m,wars,wars.length);
  add_text(m);  
  // (ZOOMED IN VERSION)
  // START AND END YEARS FOR WAR AREA HIGHLIGHT 
  for (var i=0;i<wars.length;i++)
  {
    war(wars[i].start_year,wars[i].end_year,m);
  }
  
 //******** ARTWORK_POINTS PLOTTING *****************// 
   art_point(arts,m);
   
 // ************ SKETCHING THE GRIDS *******************//
  
  //small first loop
  for (var i =0 ; i<b*(m-10) ; i=i+b)
  {
    stroke (0,0,0,100);
    strokeWeight(0.1);
    noFill();
    ellipse(x,y,i, i);
  }
  
  //big loop
  for (var i =b*(m-10) ; i<(b*(m-10))+(a*10); i=i+a)
  {
    stroke (0,0,0,150);
    strokeWeight(0.5);
    noFill();
    ellipse(x,y,i, i);
  }
  
  //small second loop
  for (var i =(b*(m-10))+(a*10) ; i<(b*(m-10))+(a*10)+(b*(100-m)) ; i=i+b)
  {
    stroke (0,0,0,100);
    strokeWeight(0.1);
    noFill();
    ellipse(x,y,i, i);
  }
}