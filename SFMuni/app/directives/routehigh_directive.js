/**************************  Directive sfMapDir Starts ***************************/

sfmuniapp.directive('routehigh',function(){
	
 	return{
    		restrict :'E',
    		scope:
    		{
    			projection : '=',
    			mapsvg: '=',
    			vehicletag: '='
    		},
    		link:function(scope,element,attrs)
    		{
    			   	
/***************************  Route Starts ***************************/
			scope.$watchGroup(['projection','mapsvg','vehicletag'],function(data){

			projection = data[0];
    		mapsvg = data[1];
    		vehicletag = data[2];

    		
    		$("#high").remove();

			if(projection)
			{

			var map_svg = mapsvg;

			var loc = "assets/data/sfmuni/muni_"+vehicletag+".xml";

			var q = d3.queue(),
					dataSource = loc;

			q.defer(function (callback){
					d3.xml(dataSource,callback);
					})
		

			var high_map = map_svg.append("g")
								.attr("id","high");
			
			q.awaitAll(function(error,results){
			for (var r_c = 0 ; r_c < results.length ;r_c++)
			{
				var info = route_info(results[r_c]);
				high_map.append("g")
							.attr("id","stop")
							.selectAll("circle")
							.data(info.stops)
							.enter()
							.append("circle")
							.attr('cx',function(d){return d.x})
							.attr('cy',function(d){return d.y})
							.attr('r',2)
							.attr('id',function(d){return d.title})
							.attr("fill","black")


				high_map.append("g")
						.attr("class","outbound")
						.attr("id",'outbound_'+info.tag)
						.selectAll("polyline")
						.data(info.outbound_path)
						.enter()
          				.append("polyline")
          				.attr("class","outbound_path")
          				.attr("stroke-width",4)
          				.attr("stroke-opacity",0.7)
          				.attr("points",function(d) {return d;})
          				.attr("stroke",'#'+info.col);


         // /************ Activate with button CLICK *******************/
					high_map.append("g")
							.attr("class","inbound")
							.attr("id",'inbound_'+info.tag)
							.selectAll("polyline")
						.data(info.inbound_path)
						.enter()
							.append("polyline")
							.attr("class","inbound_path")
							.attr("stroke-width",4.0)
							.attr("stroke-opacity",0.3)
							.attr("points",function(d) {return d;})
							.attr("stroke",'#'+info.col);

					var width = 2*window.innerWidth/3;
					var height = window.innerHeight;
					var margin = 40;

		// Vehicle title
				high_map.append("g")
						.attr("class","vehicle_text")
						.append("text")
						.text((info.title).toUpperCase())
						.attr("font-family", "sans-serif")
						.attr("text-anchor","middle")
                 		.attr("font-size", "20px")
                 		.attr("fill", '#'+info.col)
                 		.attr("opacity",0.8)
						.attr("x",width/2)
						.attr("y",height-40);

			}
		})

		}

	})
		}

	}
})
