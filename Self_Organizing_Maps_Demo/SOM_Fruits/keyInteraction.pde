void keyPressed()
{
  if ( key == ' ' && training_start == false)
  {
    training_start = true;
  }
  else if ( key == ' ' && training_start == false)
  {
    training_start = false;
  }
  if(key == '1')
  {
    u_map = false; 
    color_map = true; 
  }
  if( key == '2')
  {
    u_map = true; 
    color_map = false; 
  }
  if(key == '3')
  {
    randomize = true; 
  }
}