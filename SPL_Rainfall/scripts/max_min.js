//Function to get max value from a 2d array
function max2D(array2D,column,len) {
  var max = 0;
  for (var i=0; i<len; i++) {
    var j =column;
      if (Number(array2D[i][j]) > max) {
        max = Number(array2D[i][j]);
      }
  }
  return max;
}

//Function to get min value from a 2d array
function min2D(array2D ,column, len) {
  var max = max2D(array2D , column, len);
  var min = max;
  for (var i=0; i<len; i++) 
    {
      if (Number(array2D[i][column]) < min) 
      {
        min = Number(array2D[i][column]);
      }
    }
  return min;
}