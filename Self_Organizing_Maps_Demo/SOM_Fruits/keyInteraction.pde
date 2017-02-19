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
    error_map = false; 
    color_map = true; 
  }
  if( key == '2')
  {
    error_map = true; 
    color_map = false; 
  }
  if(key == '3')
  {
    randomize = true; 
  }
}