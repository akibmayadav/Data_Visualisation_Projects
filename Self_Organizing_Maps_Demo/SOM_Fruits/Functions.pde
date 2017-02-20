float[][] kohonen_weights()
{
 for (int i = 0 ;i < total_number_of_nodes;i++)
 {
   // assigning random values for every weight .
   nodes_array[i][0]=int(random(upper_node_weight[0]+1));
   nodes_array[i][1]=int(random(upper_node_weight[0]+1));
   nodes_array[i][2]=int(random(upper_node_weight[0]+1));
   nodes_array[i][3]=int(random(upper_node_weight[0]+1));
   nodes_array[i][4]=int(random(upper_node_weight[0]+1));
   nodes_array[i][5]=int(random(upper_node_weight[0]+1));
 }
 
 // Randomly placing this shufflig here 
 access_input_vectors = new Integer[input_vectors.length];
 for ( int i = 0 ; i <input_vectors.length ;i++)
 {
   access_input_vectors[i] = new Integer(i);
 }
 
 return nodes_array;
}

float what_is_the_radius()
{
  float radius_1 = (width-200-(width_margin*2))/(sqrt(3)*nodes_horizontal);
  float radius_2 = height-(height_margin*2)/(1.5*nodes_vertical);
  float radius ;
  if( radius_1>radius_2)
    radius = radius_2;
  else 
    radius = radius_1;
    
  return radius;
}

void draw_nodes()
{
  float y_start = height_margin +radius;
  float x_start = width_margin + radius;
  for ( int i = 0 ; i < nodes_horizontal ;i++)
  {
    for( int j = 0 ; j < nodes_vertical ;j++)
    {
     fill(random_colors_for_labelling[int(nodes_array[i+j*nodes_horizontal][0])],100);
     float x = ((j%2)*sqrt(3)/2*radius)+x_start+i*sqrt(3)*radius; 
     float y = y_start+j*1.5*radius;
     hexagon(x,y,radius);
    }
  }
}

void best_match_label(int colo_r, int colo_g , int colo_b)
{
  float y_start = height_margin +radius;
  float x_start = width_margin + radius;
  for ( int i = 0 ; i<access_input_vectors.length ; i++)
  {
    int bmu = best_match_unit(access_input_vectors[i]);
    fill(colo_r,colo_g,colo_b);
    noStroke();
    ellipseMode(CENTER);
    int v_pos = bmu/nodes_horizontal;
    int h_pos = bmu%nodes_horizontal;
    float x = ((v_pos%2)*sqrt(3)/2*radius)+x_start+h_pos*sqrt(3)*radius; 
    float y = y_start+v_pos*1.5*radius;
    ellipse(x,y,4,4);
    textAlign(CENTER,CENTER);
    textSize(10);
    text(i_vectors_table.getString(access_input_vectors[i],0).toUpperCase(),x,y+10);
  }
}

void draw_input_vectors()
{
  fill(30,30,30);
  rect(width- 200, 0, 200,height);
  fill(255,255,255,100);
  textAlign(CENTER,CENTER);
  text("INPUT DATA VECTORS",width-100,30);
  int y_start = 100;
  int rad = 22;
  for (int i = 0 ; i <input_vectors.length ;i++)
  {
    fill(random_colors_for_labelling[int(input_vectors[i][0])],100);
    hexagon(width-150,y_start+i*(2*rad+10),rad);
    fill(255,255,255,100);
    textAlign(LEFT,CENTER);
    text(i_vectors_table.getString(i,0).toUpperCase(),width-100,y_start+i*(2*rad+10));
  }
}


void hexagon(float x, float y , float r)
{
  float angle = TWO_PI / 6;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a+PI/6) * r;
    float sy = y + sin(a+PI/6) * r;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

int best_match_unit(int input)
{
  int bmu=0 ;
  float bestFitDistance = 1000;
  for ( int i = 0 ; i<nodes_array.length ;i++)
  {
    float sum = 0 ; 
    for( int j = 0 ; j < number_of_node_weights ;j++)
    {
      sum += sq(nodes_array[i][j]-input_vectors[input][j]);
    }
    float distance = sqrt(sum);
    if(distance <= bestFitDistance)
    {
      bestFitDistance = distance;
      bmu = i;
     }
  }
  
  return bmu ;
}

float neighbour_distance = 0.0;
void train_SOM()
{
  Collections.shuffle(Arrays.asList(access_input_vectors));
  if ( iterationCounter<max_iterations)
  {
    float y_start = height_margin +radius;
    float x_start = width_margin + radius;
    neighbour_distance = 40+((height-2*height_margin)/4*(1-(iterationCounter/max_iterations)));
    //println(neighbour_distance,iterationCounter/max_iterations);
    for ( int i = 0 ; i < access_input_vectors.length; i++)
    {
      int bmu = best_match_unit(access_input_vectors[i].intValue());
      for ( int node = 0 ; node<nodes_array.length; node++)
      {
          int v_pos = node/nodes_horizontal;
          int h_pos = node%nodes_horizontal;
          float nodeX = ((v_pos%2)*sqrt(3)/2*radius)+x_start+h_pos*sqrt(3)*radius; 
          float nodeY = y_start+v_pos*1.5*radius;
          int v_pos_bmu = bmu/nodes_horizontal;
          int h_pos_bmu = bmu%nodes_horizontal;
          float bmuX = ((v_pos_bmu%2)*sqrt(3)/2*radius)+x_start+h_pos_bmu*sqrt(3)*radius; 
          float bmuY = y_start+v_pos_bmu*1.5*radius;
          
          float nodeDistance = constrain(dist(nodeX,nodeY,bmuX,bmuY),0,neighbour_distance);
          for ( int j = 0 ; j <number_of_node_weights;j++)
          {
            if (nodeDistance == 0)
            {
              nodes_array[node][j] = input_vectors[access_input_vectors[i].intValue()][j];
            }
            else 
            {
              float percent = learningRate*(1-(nodeDistance/neighbour_distance));
              nodes_array[node][j]= (1-percent)*nodes_array[node][j] + percent*input_vectors[access_input_vectors[i].intValue()][j];
            }
            }
          }
      }
    }
     iterationCounter++;
  }
  
  void u_map_draw(){
    for (int node=0; node<nodes_array.length; node++){
      float nodeValue=0;
      int v_pos = node/nodes_horizontal;
      int h_pos = node%nodes_horizontal;
      for (int i=0; i<number_of_node_weights; i++){
        float adjacentWeights=0;
        int numWeightsChecked=0; 
        boolean its_a_right_corner = true;
        boolean its_a_left_corner = true;
        if(node%nodes_horizontal != 0){
          adjacentWeights += nodes_array[node-1][i]; 
          numWeightsChecked++;
          its_a_left_corner = false;
        }
        if(node%nodes_horizontal != nodes_horizontal-1){
          adjacentWeights += nodes_array[node+1][i];
          numWeightsChecked++;
          its_a_right_corner = false;
        }
        if(v_pos>=1 & v_pos<nodes_vertical-1 & its_a_left_corner == false & its_a_right_corner == false & v_pos%2 == 0)
        {
          adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
          adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos+1][i];
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos][i];
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos+1][i];
          numWeightsChecked += 4;
        }
        if(v_pos>=1 & v_pos<nodes_vertical-1 & its_a_left_corner == false & its_a_right_corner == false & v_pos%2 != 0)
        {
          adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
          adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos-1][i];
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos][i];
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos-1][i];
          numWeightsChecked += 4;
        }
        
        if (v_pos==0)
        {
          if(its_a_right_corner)
          {
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos][i];
          numWeightsChecked += 1;
          }
          else
          {
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos][i];
          adjacentWeights += nodes_array[((v_pos+1)*(nodes_horizontal))+h_pos+1][i];
          numWeightsChecked +=2;
          }
        }
        
        
        if(v_pos == nodes_vertical-1)
        {
          if(v_pos%2 ==0)
          {
            if(its_a_right_corner)
            {
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
              numWeightsChecked +=1;
            }
            else
            {
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos+1][i];
              numWeightsChecked +=2;
            }
          }
          else
          {
            if(its_a_left_corner)
            {
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
              numWeightsChecked +=1;
            }
            else
            {
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos][i];
              adjacentWeights += nodes_array[((v_pos-1)*(nodes_horizontal))+h_pos-1][i];
              numWeightsChecked +=2;
            }
          }
        }

        nodeValue += abs(nodes_array[node][i] - (adjacentWeights/numWeightsChecked));
      }

      fill(255-20*nodeValue);
      float y_start = height_margin +radius;
      float x_start = width_margin + radius;
      float nodeX = ((v_pos%2)*sqrt(3)/2*radius)+x_start+h_pos*sqrt(3)*radius; 
      float nodeY = y_start+v_pos*1.5*radius;
      hexagon(nodeX,nodeY,radius);
    }
  }