void keyPressed()
{
  if ( key == ' ')
  {
    training_start = true;
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