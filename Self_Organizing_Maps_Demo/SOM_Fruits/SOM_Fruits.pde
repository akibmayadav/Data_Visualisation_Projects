// Semantic SOM Implementation  For  Fruit Like Attributes    // 
// Created By Ambika Yadav          //
// Supervisor : Prof George Legrady //
// Inspired By Mike Godwin Demo     // 

/* INSTRUCTIONS*/
// Press Space to start training    // 
// Press 1 for color Map obtained by fruit color //
// Press 2 for error Map //


import java.util.*;

//Kohonen Parameters
float max_iterations = 250;
float learningRate = 0.25;
int iterationCounter = 0;
//Margins
int width_margin = 30; 
int height_margin = 20;
float radius ; 

// NODE PROPERTIES
int nodes_vertical = 34; 
int nodes_horizontal =30; 
int number_of_node_weights = 5;
int[] upper_node_weight = {5,2,1,1,1};


int total_number_of_nodes = nodes_vertical * nodes_horizontal;
float[][] nodes_array = new float[total_number_of_nodes][number_of_node_weights];

// Input Data Vectors
Table i_vectors_table;
float[][] input_vectors;
Integer[] access_input_vectors;

//Labelling Colors
color[] random_colors_for_labelling = {#ff4d4d,#e65f10,#ffe41a,#2eb82e,#0099e6,#804000};

//Interaction
boolean training_start= false; 
boolean color_map = true; 
boolean error_map = false;

int colo_r,colo_g,colo_b;
void setup()
{
  size(1000,800);
  
  // Loading Input Data vectors
  i_vectors_table = loadTable("input_vectors.csv","header");
  input_vectors = new float[i_vectors_table.getRowCount()][i_vectors_table.getColumnCount()-1];
  for( int i = 0 ; i < i_vectors_table.getRowCount() ;i++)
  {
    for( int j = 0 ; j < i_vectors_table.getColumnCount()-1 ;j++)
    {
      input_vectors[i][j]=i_vectors_table.getInt(i,j+1);
    }
  }
  
  
  // Loading a random matrix, node_array.
  nodes_array = kohonen_weights();
  radius = what_is_the_radius();

}
void draw()
{
  background(0,0,0);
  draw_input_vectors();
  
  if (training_start)
  train_SOM();
  if (color_map)
  {
  draw_nodes();
  colo_r = colo_b = colo_g =255;
  }
  if (error_map)
  {
  error_map();
  colo_r = 255;
  colo_g = 0; 
  colo_b = 0;
  }
    
  best_match_label(colo_r,colo_g,colo_b);
  
}