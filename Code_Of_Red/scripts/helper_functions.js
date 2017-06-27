 // ******INTERACTION TO GO THROUGH ALL THE COUNTRIES ******//

  var x_rectlen = 500; // x length
  //var x_rectlen = 900 - (2*x_rector); // length in x
  var y_rectlen = 15; // length in y
  var x_rector = (window.innerWidth/4)-(x_rectlen/2); // x position
  var y_rector = window.innerHeight-250 // y position


function keyPressed()
{
  if (key == ' ' )
  {
    key_press=(key_press+1)%22;
  }
}

function country_interaction(country_name)
{
  //textFont(trial1);
  fill(0,0,0);
  textSize(25);
  text(country_name,window.innerWidth/4,window.innerHeight-280); 
  return key_press;
}

function art_year_count(arts)
{ 
  var count = 0;
  for (var i=1;i<arts.length;i++)
  {
  var artist_1 = arts[i].artist_name;
  var artist_2 = arts[i-1].artist_name;
  //console.log(artist_1,artist_2);
  if (artist_1 == artist_2)
  {
   if ( arts[i].year == arts[i-1].year )
    {
      count  = count+1;
    }
    else 
    {
      count = 0;
    }
   count_year[i]= count;
  }
  }
  
  for (var i =0;i<arts.length-1;i++)
  {
    if (count_year[i]>=count_year[i+1])
    {
      for (var j = i-count_year[i]; j<i+1 ;j++)
      {
        total_count[j]=count_year[i]+1;
      }
    }
  }
}

// *** SLIDER FOR ZOOMING INTO TIME *** //

function zoom_year_slider()
{
  var x_rectlen = 500; // x length
  //var x_rectlen = 900 - (2*x_rector); // length in x
  var y_rectlen = 15; // length in y
  var x_rector = (window.innerWidth/4)-(x_rectlen/2); // x position
  var y_rector = window.innerHeight-250 // y position
 
  var cursor_len =x_rectlen/10; // length of cursor 
  noStroke();
  fill(255,0,0,60);
  rect(x_rector,y_rector,x_rectlen,y_rectlen,4);
  var position_retained=x_rector;
  var m = 10;
  var count =0;
  
  //***************** LABELS ********************//
  for ( var t = x_rector ; t <= x_rectlen+x_rector ;t = t+(cursor_len))
  {
    fill(0,0,0);
    stroke(0,0,0);
    strokeWeight(1);
    line (t,y_rector+17,t,y_rector+27);

    textSize(13);
    textAlign(CENTER);
    strokeWeight(0);
    text(1900+count*10, t,y_rector +39);
    
    count =count+1;
  }
  
  //****************** CURSOR POSITION *************************//
  fill(0,0,0,100);
  noStroke();
  if ((mouseX-(cursor_len/2)>=x_rector) && (mouseX+(cursor_len/2)<x_rector+x_rectlen) && (mouseY>=y_rector-10) && (mouseY<=y_rector+y_rectlen+10))
  {
  var m_i = map(mouseX-(cursor_len/2),x_rector,x_rector+x_rectlen,0,100)+10;
  m= int(m_i);
  // moving cursor rectangle
  rect(mouseX-(cursor_len/2),y_rector+3,cursor_len,y_rectlen-6,10);
  position_retained = mouseX-(cursor_len/2);
  }
  else 
  {
  rect(position_retained,y_rector+3,cursor_len,y_rectlen-6,10);  
  }
  noFill();
  return m;
}


//*** LISTING OUT WAR NAMES ***//
function war_name_display(m , wars, war_data_rowNums)
{


  var year_start = 1900+m-10;
  var year_end = 1900+m;

  textSize(20);
  fill(0,0,0);
  textAlign(CENTER);
  text("WARS",x_rector+x_rectlen/2,y_rector+70);


  textSize(15);
  textAlign(CENTER);
  var count =0;
  var a = new Array();
  //a = new String[40];
  for (var i =0;i<war_data_rowNums;i++)
  {
    if (((wars[i].start_year> year_start) && (wars[i].start_year< year_end))||((wars[i].end_year> year_start) && (wars[i].end_year< year_end)))
    {
      a[count] = (wars[i].war_name +" "+wars[i].start_year+ "-" + wars[i].end_year);
      count = count +1;   
    }
  }
  for (var j=0;j<count;j++)
  {
    text(a[j],x_rector+x_rectlen/2,y_rector+100+(j*15));
  }
}

//*** HIGHLIGHTING WAR AREAS ***//

function war ( table_start_year , table_end_year , m)
{
  // INDEXING THE START AND END YEARS OF WARS AND STORING IN AN ARRAY
  var start_year,end_year;
  if (table_start_year==table_end_year)
  {
  start_year = table_start_year - 1900+2 ;
  end_year = table_end_year - 1900+2 ;
  }
  else
  {
  start_year = table_start_year - 1900+2 ;
  end_year = table_end_year - 1900+2 ;
  }
  var num_index = 0;
  for ( var index = start_year ; index <= end_year ; index++)
  {
    year_index[num_index]=index-1;
    num_index=num_index+1;
  }
  
  
  // HIGHLIGHTING WAR YEARS USING RED TINGE
  for ( var which_ell = 0 ; which_ell <num_index ; which_ell++)
  { 
     
    if ((year_index[which_ell]>=0) && (year_index[which_ell]<=(m-10))) // if in  FIRST SMALL LOOP
    {
      var radius = b*year_index[which_ell] -b/2;
      stroke(226, 54, 54,50);
      strokeWeight(b/2);
      fill(0,0,0,0);
      ellipse(x,y,radius,radius);      
    }

    else if ((year_index[which_ell]>=(m-9)) && (year_index[which_ell]<=m)) // if in BIG LOOP
    {
      var radius = b*(m-10) + a*(10-(m-year_index[which_ell]))-a/2;
      stroke(226, 54, 54,50);
      strokeWeight(a/2);
      fill(0,0,0,0);
      ellipse(x,y,radius,radius);
    }

    else if ((year_index[which_ell]>=(m-101)) && (year_index[which_ell]<=(101))) // if in SECOND SMALL LOOP
    {
      var radius = a*10 + b*(year_index[which_ell]-11) -b/2;
      stroke(226, 54, 54,50);
      strokeWeight(b/2);
      fill(0,0,0,0);
      ellipse(x,y,radius,radius);
    }
    
  }
}

//****** TO PLOT ARTWORK ON THE GRID ******//

function art_point(arts, m)
{
var artist_count = 0;
var angle_index_intialisation = 0;
var angle_index = new Array();
for (var i=1;i<arts.length;i++)
{
  var artist_1 = arts[i].artist_name;
  var artist_2 = arts[i-1].artist_name;
  if (artist_1 != artist_2)
  {
    artist_count = artist_count +1;
    angle_index_intialisation = angle_index_intialisation+1;  
  }
  angle_index[i]=angle_index_intialisation;
}
var angle = new Array();
for (var i =0 ; i <arts.length ;i++)
{
// ANGLE FOR EVERY DATA POINT
  var n = 0;
  angle [i] = 2*PI*angle_index[i]/artist_count;
  if (((angle[i]>=0) && (angle[i]<=PI/2))|| ((angle[i]>=3*PI/2) && (angle[i]<=2*PI))) 
  {
    n = 1;
  }
  if ((angle[i]>=PI/2) && (angle[i]<=3*PI/2))
  {
    n = -1;
  }

// PLOTTING THE POINTS (RADIUS)
  art_year[i] = arts[i].year - 1900+1 ;
  if ((art_year[i]>=0) && (art_year[i]<=(m-10))) // if in  FIRST SMALL LOOP
  {
    var radius = b*art_year[i] -((b*(count_year[i]+1))/(2+total_count[i]));
    stroke(0,0,0);
    strokeWeight(1.5);
    var x_m = radius/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    var y_m = (radius*tan(angle[i]))/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    point(x+(n*x_m)/2,y+(n*y_m)/2);
  }
  else if ((art_year[i]>=(m-9)) && (art_year[i]<=m)) // if in BIG LOOP
  {
    var radius = b*(m-10) + a*(10-(m-art_year[i]))-((a*(count_year[i]+1))/(2+total_count[i]));
    stroke(0,0,0);
    strokeWeight(2.5);
    var x_m = radius/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    var y_m = (radius*tan(angle[i]))/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    point(x+(n*x_m)/2,y+(n*y_m)/2);
  }
  else if ((art_year[i]>=(m-101)) && (art_year[i]<=(101))) // if in SECOND SMALL LOOP
  {
    var radius = a*10 + b*(art_year[i]-11) -((b*(count_year[i]+1))/(2+total_count[i]));
    stroke(0,0,0);
    strokeWeight(1.5);
    var x_m = radius/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    var y_m = (radius*tan(angle[i]))/(sqrt(1+(tan(angle[i])*tan(angle[i]))));
    point(x+(n*x_m)/2,y+(n*y_m)/2);
  } 
}

}

//****** ADDING TEXT ******//

function add_text(m)
{
  var x_position = window.innerWidth/4;

  textFont(text_font);

  textAlign(CENTER);

  fill(160,0,0,200);
  textSize(70);
  text("CODE OF RED",window.innerWidth/4,100);
  
  fill(0,0,0);
  textSize(20);
  text(" A PALLETE OF WAR AND ART ",window.innerWidth/4,120);
  
  textSize(15);
  text(" | Visualizing the dependency of artwork on war periods | ",window.innerWidth/4,140);
  
  textSize(14);
  text("Code of Red is an interactive visualization that examines the impact of war on artistic creation over the last century. Specifically, it enables the audience to explore the ways in which wartime affects artists. Does war always oppressor can it have the opposite effect, provoking an outpouring of thoughts and ideas into the world ? This visualization is intended to evoke questions about why artistic creation may be important in the context of war, how it may be serving as a coping mechanism or as a tool to elicit new perspectives ones which may help present and future generations reflect on the power of their actions to bring about good instead of ill ? \n \n Regarding the design, users can observe trends of artistic output for groups of artists both as a whole worldwide and within certain countries. The layout is organized like the cross-section of a tree, with each year represented by a ring, 1900 being the innermost layer and 2000 being the outermost one.?The user can scroll through any 10-year period for a more detailed examination. Each artist is represented by a unique, invisible line that radiates out from the center of the work. Each of their artworks delineate this line with a black dot placed according to the year of the given work’s creation. Wartime year rings are tinged with red. \n \n Thus, like with the tree, one can easily read the responses of the societal organism to years of extreme duress. Although the individual tree may be powerless to change the weather it endures, as a society, through art, we may seed winds of change. Knowing this, we may reduce the number of bloodstained rings to come, learning from the past to fortify the future health of the whole.",(window.innerWidth/4)-320,170,640,800);
  
  textAlign(LEFT);
  textSize(20);
  text(1900+m-10,window.innerWidth/4-60,660);
  text("-",window.innerWidth/4-5,660);
  text(1900+m,window.innerWidth/4+10,660);
  
  //noFill();
  
  textSize(16);
  textAlign(CENTER);
  fill(0,0,0);
  text ("| USE SPACE BAR TO NAVIGATE THROUGH COUNTRIES | \n| SCROLL TO VIEW ACROSS YEARS |",window.innerWidth/4,window.innerHeight-340);

 
}