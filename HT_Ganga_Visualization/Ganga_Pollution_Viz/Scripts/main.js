var innerWidth = 700;
var innerHeight = 700;

var main_svg =  d3.select("body")
				.append("svg")
				.attr("width", innerWidth)
				.attr("height", innerHeight);


var mercator = d3.geoMercator() 
				.rotate([0,-20,0])
				.fitExtent([[0,0],[innerWidth,innerHeight]],ganga_states) ;

var path = d3.geoPath()               
		  	 .projection(mercator); 

var g_states = main_svg.append("svg")
						.attr("id","Main_Base_Map")
						.selectAll("path")
						.data(ganga_states.features)
						.enter()
						.append("path")
						.attr("fill","#E8E8DC")
						.attr("stroke","#C7C4AB")
						.attr("stroke-width",0.5)
						.attr("opacity",0.7)
						.attr("d",path);

var ganga_path = main_svg.append("svg")
						.attr("id","Ganga_Outline")
						.selectAll("path")
						.data(ganga_data.features)
						.enter()
						.append("path")
						.attr("fill","none")
						.attr("stroke","#73C7D6")
						.attr("stroke-width",5.0)
						.attr("opacity",1.0)
						.attr("d",path);

var cities = main_svg.append("svg")
						.attr("id","Major_Cities")
						.selectAll("circle")
						.data(cities.features)
						.enter()
						.append("circle")
						.attr("cx",function(d){return (mercator(d.geometry.coordinates))[0]})
						.attr("cy",function(d){return (mercator(d.geometry.coordinates))[1]})
						.attr("r",2)
						.attr("opacity",0.7);


console.log(ganga_states);



