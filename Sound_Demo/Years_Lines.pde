void year_2016()
{
  checkouts_2016 = loadTable("Checkouts_2016.csv","header");
  numrows_2016 = checkouts_2016.getRowCount();
  
  dataMatrix_2016 = new float[numrows_2016];
  for ( int i = 0 ; i < numrows_2016; i ++)
  {
    dataMatrix_2016[i] = checkouts_2016.getFloat(i,0);
  }
  
  maxvalue_2016 = max(dataMatrix_2016);
  minvalue_2016 = min(dataMatrix_2016);
  
  y_start_2016 = 500;
  x_start_2016 = 225;
  for ( int i = 0 ; i < numrows_2016; i ++)
  {
  float length_of_line = map( dataMatrix_2016[i],minvalue_2016,maxvalue_2016,10,70);
  stroke(#ffc300);
  strokeWeight(1.0);
  line(x_start_2016+i*dist,y_start_2016+length_of_line/2,x_start_2016+i*dist,y_start_2016-length_of_line/2);
  }
}

void year_2015()
{
  checkouts_2015 = loadTable("Checkouts_2015.csv","header");
  numrows_2015 = checkouts_2015.getRowCount();
  
  dataMatrix_2015 = new float[numrows_2015];
  for ( int i = 0 ; i < numrows_2015; i ++)
  {
    dataMatrix_2015[i] = checkouts_2015.getFloat(i,0);
  }
  
  maxvalue_2015 = max(dataMatrix_2015);
  minvalue_2015 = min(dataMatrix_2015);
  
  y_start_2015 = 350;
  x_start_2015 = 225;
  for ( int i = 0 ; i < numrows_2015; i ++)
  {
  float length_of_line = map( dataMatrix_2015[i],minvalue_2015,maxvalue_2015,10,70);
  stroke(#c70039);
  strokeWeight(1.0);
  line(x_start_2015+i*dist,y_start_2015+length_of_line/2,x_start_2015+i*dist,y_start_2015-length_of_line/2);
  }
}


void year_2014()
{
  checkouts_2014 = loadTable("Checkouts_2014.csv","header");
  numrows_2014 = checkouts_2014.getRowCount();
  
  dataMatrix_2014 = new float[numrows_2014];
  for ( int i = 0 ; i < numrows_2015; i ++)
  {
    dataMatrix_2014[i] = checkouts_2014.getFloat(i,0);
  }
  
  maxvalue_2014 = max(dataMatrix_2014);
  minvalue_2014 = min(dataMatrix_2014);
  
  y_start_2014 = 200;
  x_start_2014 = 225;
  for ( int i = 0 ; i < numrows_2014; i ++)
  {
  float length_of_line = map( dataMatrix_2014[i],minvalue_2014,maxvalue_2014,10,70);
  stroke(#ff5733);
  strokeWeight(1.0);
  line(x_start_2014+i*dist,y_start_2014+length_of_line/2,x_start_2014+i*dist,y_start_2014-length_of_line/2);
  }
}