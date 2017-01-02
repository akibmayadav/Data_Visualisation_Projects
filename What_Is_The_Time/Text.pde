void title()
{
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD(); // peasy cam stops working here
 
  // storing mouse x and y values here in a global variable
  mouse_x=mouseX;
  mouse_y=mouseY;
  
  // new font assignment 
  font=createFont("Helvetica-Light-48.vlw", 32);
  fill(#FFFFFF);
  textFont(font);
  textSize(30);
  text("WHAT IS THE TIME ?", 30, 50);
  textSize(15);
  text("VISUALIZING CHECKOUTS WITH TIME EVERY DAY FOR THE PAST 10 YEARS " ,35,78);
  text("MAT 259 - VISUALIZING INFORMATION",35,96);
  text("AMBIKA YADAV",35,114);
  
  // times through the day, drawing lines 
  textSize(12);
  int i =152,d=20;// shifting all the lines up or to the side
  strokeWeight(7);
  stroke(#FFFFFF);
  line(20,0,0,20,132,0);
  stroke(#B76F90);
  line(20,132,0,20,152,0);
  for (int n =0;n<23;n++)
  {
    stroke(c[n+1]);
    line(20,i+n*d,0,20,i+(n+1)*d,0);
    col_y_s[n] =i+n*d ;
    col_y_e[n]=i+(n+1)*d ;
  }
  for (int n =0;n<24;n++)
  {
    text(time[n],27,i+n*d-5,0);
  }
  
  // text for years
  int i1 =1230,d1=35;
  String year1[]={"2006","2007","2008","2009","2010","2011","2012","2013","2014"};
  for (int n =0;n<9;n++)
  {   
    fill(#FFFFFF,opacity[n]);
    textSize(30);
    text(year1[n],i1+n*(d1+50),60,0);   
  }
  cam.endHUD(); // start peasy cam again
  hint(ENABLE_DEPTH_TEST);
}