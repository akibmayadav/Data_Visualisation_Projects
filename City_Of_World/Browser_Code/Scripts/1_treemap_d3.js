var width = 960;
var height = 570;

var treemap = d3.treemap()
    .tile(d3.treemapResquarify)
    .size([width, height])
    .round(true)
    .paddingInner(5);

var background_color_for_three = new THREE.Color("hsl(217,100%,12%)");
var current_year = 1955;

function year_update(x)
{
    $("canvas").remove();
    current_year = x;
    reset_buttons();
    switch (current_year)
    {
        case (1955) : $("#b_1955").css("background-color","#FF5533");break;
        case (1960) : $("#b_1960").css("background-color","#FF5533");break;
        case (1965) : $("#b_1965").css("background-color","#FF5533");break;
        case (1970) : $("#b_1970").css("background-color","#FF5533");break;
        case (1975) : $("#b_1975").css("background-color","#FF5533");break;
        case (1980) : $("#b_1980").css("background-color","#FF5533");break;
        case (1985) : $("#b_1985").css("background-color","#FF5533");break;
        case (1990) : $("#b_1990").css("background-color","#FF5533");break;
        case (1995) : $("#b_1995").css("background-color","#FF5533");break;
        case (2000) : $("#b_2000").css("background-color","#FF5533");break;
        case (2005) : $("#b_2005").css("background-color","#FF5533");break;
        case (2010) : $("#b_2010").css("background-color","#FF5533");break;
        case (2015) : $("#b_2015").css("background-color","#FF5533");break;
    }
    year_update_inside(current_year);

}

function reset_buttons()
{
    $("#b_1955").css("background-color","#CCB400");
    $("#b_1960").css("background-color","#CCB400");
    $("#b_1965").css("background-color","#CCB400");
    $("#b_1970").css("background-color","#CCB400");
    $("#b_1975").css("background-color","#CCB400");
    $("#b_1980").css("background-color","#CCB400");
    $("#b_1985").css("background-color","#CCB400");
    $("#b_1990").css("background-color","#CCB400");
    $("#b_1995").css("background-color","#CCB400");
    $("#b_2000").css("background-color","#CCB400");
    $("#b_2005").css("background-color","#CCB400");
    $("#b_2015").css("background-color","#CCB400");
}
// var container = document.getElementById( 'Treemap' );
// document.body.appendChild( container );

// var width_tree = window.innerWidth - 400;
// var height_tree = window.innerHeight/2;

year_update_inside(current_year);

/*** Importing the surface area Data ***/  
function year_update_inside(x)
{  
var table = d3.csv("Data/Final_Data.csv",function(csv_data){


	/*** Parsing Data into TreeMap and Getting x,y coordinates for the Treemap ***/
	var sum = 0 ; 
	for (var a = 0 ; a <csv_data.length ;a++)
	{
		sum += parseInt(csv_data[a].Value);
	}

	var new_obj ={}; 
	new_obj.Parent ="";
	new_obj.country = "World";
	new_obj.Value = sum ; 

	csv_data.push(new_obj);

	var root_l1 = d3.stratify()
    .id(function(d) { return d.country; })
    .parentId(function(d) { return d.Parent; })
    (csv_data);

    var m = 0 ; 
    var root = root_l1
    	.sum(function(d){ 
    		m = m+1;
    		var temp = parseInt(d.Value);
    		if ( m < csv_data.length)
    			return temp; 
    		else 
    			return 0;
    	});
	
    treemap(root);
    /*** Drawing the Treemap Using Three.js ***/
    draw_treemap(root,x);
    
 });
}