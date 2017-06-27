/************************  Functions ***************************/

	var width = 2*window.innerWidth/3;
	var height = 2*window.innerWidth/3;
	var margin = 20;


	function path_from_projection(data,projection)
	{
		var output = d3.geoPath()               
		  	 		.projection(projection);
		return output;
	}

	// Draw functions for sf maps
	function draw(data,map_svg,path,source,z)
	{

		var subset = map_svg.insert("g",":first-child")
							.attr("z",z)
							.order('z')
							.attr("id",source);
		subset.selectAll("path")
				.data(data.features)
				.enter()
				.append("path")
				.attr("d", path);	
	}

	//
	function load(map_svg,projection,z)
	{
		var data_loc =[];
		data_loc[1]='assets/data/sfmaps/neighborhoods.json';
		data_loc[0]='assets/data/sfmaps/streets.json';

		var sources = ['streets','neighborhoods'];
		
		var q= d3.queue()
			,dataSources =data_loc;
		
		dataSources.forEach(function(source){
				q.defer(function (callback){
							d3.json(source,callback);
						})
					})

		q.awaitAll(function(error,results){
			for ( var a = 0 ; a<results.length ;a++)
			{
				var path = path_from_projection(results[a],projection);
				draw(results[a],map_svg,path,sources[a],z);
			}
		});
	}

	function route_info(results)
	{
	var data = results.children[0].childNodes[1];
	var color = data.getAttribute('color');
	var stops_outer = data.querySelectorAll('stop');
	var stops =[];
	for ( var s_c = 0 ; s_c<stops_outer.length ;s_c++)
	{
		if(stops_outer[s_c].attributes.length>1) //leaving out direction data
		{	
			var lat = parseFloat(stops_outer[s_c].attributes[2].value);
			var lon = parseFloat(stops_outer[s_c].attributes[3].value);
			stops.push({
				tag:stops_outer[s_c].attributes[0].value,
				title:stops_outer[s_c].attributes[1].value,
				x:projection([lon,lat])[0],
				y:projection([lon,lat])[1],
				id:parseInt(stops_outer[s_c].attributes[4].value)
			})
		}
	}

	var direction = data.querySelectorAll('direction');
	var outbound_direction = direction[0];
	var inbound_direction = direction[1];

	var outbound_direction_path =[];
	outbound_direction_path[0]=[];
	
	var nodes_o =outbound_direction.querySelectorAll('stop');
	for ( var a = 0 ; a<nodes_o.length ;a++)
	{
		var tag = nodes_o[a].getAttribute('tag');
		var index = stops.findIndex(x=>x.tag==tag);
		var x = stops[index].x; 
		var y = stops[index].y;
		var p = x+','+y;
		outbound_direction_path[0].push(p);
	}

	var inbound_direction_path =[];
	inbound_direction_path[0]=[];
	
	if(!inbound_direction){ console.log(results)};
	var nodes_i = inbound_direction.querySelectorAll('stop');
	for ( var a = 0 ; a<nodes_i.length ;a++)
	{
		var tag = nodes_i[a].getAttribute('tag');
		var index = stops.findIndex(x=>x.tag==tag);
		var x = stops[index].x; 
		var y = stops[index].y;
		var p = x+','+y;
		inbound_direction_path[0].push(p);
	}

	var output={};
	output.stops = stops;
	output.inbound_path = inbound_direction_path;
	output.outbound_path = outbound_direction_path;
	output.col=color;
	output.tag = data.getAttribute('tag')+'_muni';
	output.title = data.getAttribute('title');
	return output;

	}

/***************************  Functions ***************************/

/***************************  Directive sfMapDir Starts ***************************/

sfmuniapp.directive('sfMapDir',function(){
	
 	return{
    		restrict :'E',
    		scope:
    		{
    			projection : '=',
    			mapsvg: '='
    		},
    		link:function(scope,element,attrs)
    		{
    			
    		scope.$watchGroup(['projection','mapsvg'],function(data){
    		projection = data[0];
    		mapsvg = data[1];

    		if(projection)	
    		{	

			var map_svg = mapsvg;
			load(map_svg,projection,0); //Streets and Neighborhoods
			
			d3.xml('assets/data/sfmuni/routes.xml',function(data_outer)
			{
					data_outer = [].map.call(data_outer.querySelectorAll("route"), function(route) 
						{ return{
      							id: route.getAttribute("tag"),
      							title: route.getAttribute("title")
    							};
    							data_try= data_outer[0];		
						});

					var muni_data_loc=[];
					for ( var m_c =0 ; m_c<data_outer.length ;m_c++)
					{
						var loc = "assets/data/sfmuni/muni_"+data_outer[m_c].id+".xml";
						muni_data_loc.push(loc);
					}

					var q = d3.queue(),
							dataSources = muni_data_loc;

					dataSources.forEach(function(source){
						q.defer(function (callback){
							d3.xml(source,callback);
						})
					})


					var stops_map = map_svg.append("g")
											.attr("id","stops");
					q.awaitAll(function(error,results){
						for (var r_c = 0 ; r_c < results.length ;r_c++)
						{
							info = route_info(results[r_c]);
							var stops_draw= stops_map.append("g")
												.attr("z",2)
												.attr("id",'stops_'+info.tag);

							stops_draw.append("g")
										.attr("id","stop")
										.selectAll("circle")
										.data(info.stops)
										.enter()
										.append("circle")
										.attr('cx',function(d){return d.x})
										.attr('cy',function(d){return d.y})
										.attr('r',0.5)
										.attr("opacity",0.3)
										.attr('id',function(d){return d.title})
										.attr("fill","black");

							stops_draw.append("g")
									.attr("class","outbound")
									.attr("id",'outbound_'+info.tag)
									.selectAll("polyline")
									.data(info.outbound_path)
									.enter()
          							.append("polyline")
          							.attr("class","outbound_path")
          							.attr("stroke-width",3.0)
          							.attr("stroke-opacity",0.2)
          							.attr("points",function(d) {return d;})
          							.attr("stroke",'#'+info.col);


						}
					})
					
			}); 

			}
		});
	}
}

});
/***************************  sfMapDir Ends ************************/