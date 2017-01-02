float Max ( ArrayList<Time_Data> data,int rowNums )
{
  float max = 0;
  for(int i =0 ; i< rowNums ; i++)
  if (data.get(i).count > max) {
      max = data.get(i).count;
    }
  return max;
}
float Min ( ArrayList<Time_Data> data,int rowNums )
{
  float max = Max(data,rowNums);
  float min =max;
  for(int i =0 ; i< rowNums ; i++)
  if (data.get(i).count < min) {
      min = data.get(i).count;
    }
  return min;
}