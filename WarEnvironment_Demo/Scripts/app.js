// ENVIRONMENT GRID SETUP

var environment_rows = 70; //y
var environment_columns = 100; //x

var grid_dimension = 10;
var number_of_danger_items = 100;

var danger=[];

var start = true;

for (var a = 0 ; a <number_of_danger_items ;a++)
{
	var x_p = Math.floor((Math.random() * (environment_columns-1)) + 1);
	var y_p = Math.floor((Math.random() * (environment_rows-1)) + 1);
	danger.push({"x":x_p,"y":y_p});
}

var source = {"x":49,"y":0};

var destination = {"x":49,"y":69};

var matrix_generator = function(e_rows,e_columns)
{
	var e_matrix = [];
	for (var x = 0 ; x <e_columns ;x++)
	{
		for(var y = 0 ; y<e_rows ;y++)
		{
			e_matrix[x+y*e_columns] = {"danger_index":0,
										"area_coverage":1,
										"x":x,
										"y":y};
			// danger_index 0 - safe, 1- danger
			// area_coverage  0 - 10 : how many times this position is encountered.
		}
	}

	return e_matrix;
}


var environment_matrix = matrix_generator(environment_rows,environment_columns);
danger.map(function(x) {environment_matrix[x.x+x.y*environment_columns].danger_index =1});


// DRAWING THE GRID

var environment_svg = d3.select("body")
				.append("svg")
				.attr("id","environment_svg")
				.attr("width", environment_columns * grid_dimension)
				.attr("height",environment_rows * grid_dimension);

environment_svg.selectAll("rect")
				.data(environment_matrix)
				.enter()
				.append("rect")
				.attr("id",function(d){return "grid_"+d.x+"_"+d.y})
				.attr("x",function(d){ return d.x*grid_dimension})
				.attr("y",function(d){return d.y*grid_dimension})
				.attr("width",grid_dimension)
				.attr("height",grid_dimension)
				.attr("fill",function(d){if(d.danger_index){return("#ad3c26");}
										else { return ("#2694ad")}
										})
				// .attr("stroke","black")
				.attr("opacity",function(d){return d.area_coverage*0.1});

// appending assets to the body 
var append_assets = function()
{
	var image_src = [
	{"src":"SVG/drone.svg","id":"drone_0","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/drone.svg","id":"drone_1","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/drone.svg","id":"drone_2","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/drone.svg","id":"drone_3","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/robot.svg","id":"robot_0","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/robot.svg","id":"robot_1","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/robot.svg","id":"robot_2","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/robot.svg","id":"robot_3","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	{"src":"SVG/soldier.svg","id":"soldier","style":"width:20px;height:20px;position:fixed;opacity:0.8"},
	]

	d3.select("body")
		.append("div")
		.attr("id","assets_holder")
		.selectAll("img")
		.data(image_src)
		.enter()
		.append("img")
		.attr("src",function(d){return d.src})
		.attr("id",function(d){return d.id})
		.attr("style",function(d){return d.style});
}

append_assets();

// Shading Source and Destination
$("#grid_"+destination.x+"_"+destination.y).css({'fill':"#ad3c26","opacity":0.2});
$("#grid_"+source.x+"_"+source.y).css({'fill':"#2694ad","opacity":0.2});

// POSITION OF DRONE,ROBOTS AND SOLDIER

var drone_position = [
{"x":49,"y":1},
{"x":49,"y":1},
{"x":49,"y":1},
{"x":49,"y":1}
]

var robot_position = [
{"x":49,"y":3},
{"x":49,"y":3},
{"x":49,"y":3},
{"x":49,"y":4}
]

var soldier_position ={"x":49,"y":6};

//DRAWING THE ELEMENTS
var position_finder = function(s)
{
	return {'bottom':environment_rows * grid_dimension - s.y*grid_dimension,'left':(s.x+1)*grid_dimension}
}

var draw_assets = function()
{
$("#drone_0").css({'bottom':position_finder(drone_position[0]).bottom-(grid_dimension/2),'left':position_finder(drone_position[0]).left-(grid_dimension/2)});
$("#drone_1").css({'bottom':position_finder(drone_position[1]).bottom-(grid_dimension/2),'left':position_finder(drone_position[1]).left-(grid_dimension/2)});
$("#drone_2").css({'bottom':position_finder(drone_position[2]).bottom-(grid_dimension/2),'left':position_finder(drone_position[2]).left-(grid_dimension/2)});
$("#drone_3").css({'bottom':position_finder(drone_position[3]).bottom-(grid_dimension/2),'left':position_finder(drone_position[3]).left-(grid_dimension/2)});
$("#robot_0").css({'bottom':position_finder(robot_position[0]).bottom-(grid_dimension/2),'left':position_finder(robot_position[0]).left-(grid_dimension/2)});
$("#robot_1").css({'bottom':position_finder(robot_position[1]).bottom-(grid_dimension/2),'left':position_finder(robot_position[1]).left-(grid_dimension/2)});
$("#robot_2").css({'bottom':position_finder(robot_position[2]).bottom-(grid_dimension/2),'left':position_finder(robot_position[2]).left-(grid_dimension/2)});
$("#robot_3").css({'bottom':position_finder(robot_position[3]).bottom-(grid_dimension/2),'left':position_finder(robot_position[3]).left-(grid_dimension/2)});
$("#soldier").css({'bottom':position_finder(soldier_position).bottom-(grid_dimension/2),'left':position_finder(soldier_position).left-(grid_dimension/2)});
}

// draw_assets();

var update_environment = function()
{
	// updating environment matrix 
	// from drones
	drone_position.map(function(drone_position){
	var updater = environment_matrix[drone_position.x+drone_position.y*environment_columns].area_coverage ;
	(updater<10)?(updater=updater+1):updater=10;
	environment_matrix[drone_position.x+drone_position.y*environment_columns].area_coverage = updater;
	});
	// from ground robots
	robot_position.map(function(robot_position){
	var updater = environment_matrix[robot_position.x+robot_position.y*environment_columns].area_coverage ;
	(updater<10)?(updater = updater+1):updater=10;
	environment_matrix[robot_position.x+robot_position.y*environment_columns].area_coverage = updater;
	});
	// from soldier
	var soldier_updater = environment_matrix[soldier_position.x+soldier_position.y*environment_columns].area_coverage ;
	(soldier_updater<10)?(soldier_updater = soldier_updater+1):soldier_updater = 10;
	environment_matrix[soldier_position.x+soldier_position.y*environment_columns].area_coverage = soldier_updater;

	//modifying the environment grid
	drone_position.map(function(drone_position){
	$("#grid_"+drone_position.x+"_"+drone_position.y).css({"opacity":environment_matrix[drone_position.x+drone_position.y*environment_columns].area_coverage*0.1})
	});
	robot_position.map(function(robot_position){
	$("#grid_"+robot_position.x+"_"+robot_position.y).css({"opacity":environment_matrix[robot_position.x+robot_position.y*environment_columns].area_coverage*0.1})
	});
	$("#grid_"+soldier_position.x+"_"+soldier_position.y).css({"opacity":environment_matrix[soldier_position.x+soldier_position.y*environment_columns].area_coverage*0.1})


}
update_environment();

var pos = {"x":0,"y":0};

var myTimer = setInterval(doStuff, 1000);
function doStuff() 
{
if(start)
{
update_asset_position();
update_environment();
draw_assets();
}	
// console.log(pos);
}

var which_step = function(position,step)
{
	var selector = Math.floor((Math.random() * 4) + 1);
	var stepper = Math.floor((Math.random() * step) + 1);
	var pos = {"x":position.x,"y":position.y}
	switch (selector){
		case(1):
			pos.x =position.x+stepper;
			break;
		case(2):
			pos.x =position.x-stepper;
			break;
		case(3):
			pos.y =position.y+stepper;
			break;
		case(4):
			pos.y =position.y-stepper;
			break;
	}
	return pos;
	
}

var movement = function(position,step)
{
	var pos = which_step(position,step);
	if (pos.x>=0 && pos.x<=environment_columns-1 && pos.y>=0 && pos.y<=environment_rows-1)
	{
		return pos;
	}
	else 
	{
		return movement(position,step);
	}
}

var update_asset_position = function()
{

	drone_position[0]= movement(drone_position[0],3);
	drone_position[1]= movement(drone_position[1],3);
	drone_position[2]= movement(drone_position[2],3);
	drone_position[3]= movement(drone_position[3],3);
	robot_position[0]= movement(robot_position[0],2);
	robot_position[1]= movement(robot_position[1],2);
	robot_position[2]= movement(robot_position[2],2);
	robot_position[3]= movement(robot_position[3],2);
	soldier_position =movement(soldier_position,2);	
}




