void keyPressed()
{
  if (key == ' ')
  {
    if(play == true)
    {
      sine_1.play(); 
      play = false;
      if(which_sample == final_numRows)
      {
        background(0,0,0);
        which_sample=0;
      }
    }
    else if (play == false)
    {
      sine_1.stop();
      play = true;
      
    }
  }
  
  if (key == '1')
  {
    c_2014 = true; 
    c_2015 = false;
    c_2016 = false;
    which_sample=0;
  }
  if (key == '2')
  {
    c_2014 = false; 
    c_2015 = true;
    c_2016 = false;
    which_sample=0;
  }
  if (key == '3')
  {
    c_2014 = false; 
    c_2015 = false;
    c_2016 = true;
    which_sample=0;
  }
}