
void text_on_viz()
{
   //TITLE 
   textFont(hell);
   fill(255,255,255);
   textSize(25);
   textAlign(CENTER,CENTER);
   text("SONIFICATION OF CHECKOUTS FROM SEATTLE PUBLIC LIBRARY IN 2014-2016",width/2,70);
   text("2014",150,200);
   text("2015",150,350);
   text("2016",150,500);
   
   textSize(15);
   textAlign(CENTER,CENTER);
   text("Demo For MAT-259",width/2,100);
   
   fill(255,255,255,100);
   textSize(20);
   textAlign(CENTER,CENTER);
   text("| Press SPACE to play | Use Keys 1, 2 and 3 to move between Years |",width/2,height-100);
   
   
}