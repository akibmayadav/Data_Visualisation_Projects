// Loading Data Matrix 

function load_datamatrix(table)
  {

  numRows_1 = table.getRowCount(); 
  dataMatrix_new = new Array();
  // Storing tables contents that we need into a new 2D array dataMatrix
  for (var i=0; i<numRows_1; i++) 
  {
    dataMatrix_new[i]= new Array();
    dataMatrix_new[i][0] = table.getObject(0)[i].Date;
    dataMatrix_new[i][1] = table.getObject(0)[i].TotalCheckouts;
    dataMatrix_new[i][2] = table.getObject(0)[i].Average;
  }
  return dataMatrix_new;
  }

// Start and End Angle Matrix

function defining_angles(dataMatrix_n,max_value,min_value,numRows)
  {
    var difference = (max_value - min_value)/20;
    start_angles = new Array();
    end_angles=new Array();
    for (var i =0 ; i<numRows; i++)
    {
      for (var n=0 ; n<21 ; n++)
      {
        if ((Number(dataMatrix_n[i][2])>=min_value+(difference*n))&&(Number(dataMatrix_n[i][2])<min_value+(difference*(n+1))))
        {
          start_angles[i]=n*(PI/10);
          end_angles[i]=(n+1)*(PI/10);
        } 
      }
  }
  var final_angle = new Object();
  final_angle.start_angle =  start_angles;
  final_angle.end_angle = end_angles;
  return final_angle;
  }

  function predraw_year_segregator(numRows,dataMatrix)
  {
  var change_year_index = new Array();
  var change_year_width = new Array();
  var count_year_index = 1 ;

  change_year_width.push(0);
  change_year_index.push(0);

    for ( var row_count = 0 ; row_count <numRows-1 ;row_count++ )
    {
      if (dataMatrix[row_count][0].slice(0,4) < dataMatrix[row_count+1][0].slice(0,4))
      {
        // change_year_index[count_year_index] = row_count - change_year_index[count_year_index-1];
        change_year_width[count_year_index] = row_count;
        change_year_index[count_year_index] = row_count;
        for ( var row_c = count_year_index-1 ;row_c > 0 ;row_c --)
        {
          change_year_width[count_year_index] -= change_year_width[row_c];
        }     
        count_year_index += 1;      
      }
      
    }

   var last_count = numRows;

   for ( var row_c = change_year_width.length-1 ;row_c > 0 ;row_c --)
   {
    last_count -= change_year_width[row_c];
   }    

  change_year_width.push(last_count);
  change_year_index.push(change_year_index[change_year_index.length-1]+last_count);

  var change_year_parameters_in = new Object();
  change_year_parameters_in.change_year_width = change_year_width;
  change_year_parameters_in.change_year_index = change_year_index;

  return change_year_parameters_in;

  }


  function draw_year_segregator(change_year_index,change_year_width,numRows,starting_position,margin,x_c,y_c)
  {
     for ( var t = 1 ; t < change_year_index.length-1  ; t = t +2)
   {
    stroke(0,0,1,50);
    noFill();
    var position = map(change_year_index[t],0,numRows,starting_position,window.innerHeight-margin);
    var width = map(change_year_width[t],0,numRows,0,window.innerHeight-(starting_position+margin));
    strokeWeight(width/2);
    ellipse(x_c,y_c,position-width/2,position-width/2);
   }
  }