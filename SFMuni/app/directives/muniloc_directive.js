/***************************  Functions ***************************/
function vehicle_data_parser(vehicle_input,vehicle_old_input)
                    {
                    if (vehicle_input)
                        { 
                        var old_present = false; 
                        var vehicle_old=[];
                        var vehicle = vehicle_input.querySelectorAll("vehicle");
                        if(vehicle_old_input)
                            {
                            var vehicle_older = vehicle_old_input.querySelectorAll("vehicle");
                            var tag_old = vehicle_older[0].getAttribute('routeTag');
                            var tag_new = vehicle[0].getAttribute('routeTag');
                            if(tag_old ==tag_new){old_present= true;}
                            for ( var o_c = 0 ;o_c<vehicle_older.length;o_c++)
                            {
                                var attr = {};
                                attr.id = vehicle_older[o_c].getAttribute('id');
                                var lat = vehicle_older[o_c].getAttribute('lat');
                                var lon = vehicle_older[o_c].getAttribute('lon');
                                attr.x = projection([lon,lat])[0];
                                attr.y = projection([lon,lat])[1];
                                attr.heading= vehicle_older[o_c].getAttribute('heading');
                                vehicle_old.push(attr);
                            }
                            };

                        
                        if(vehicle.length)
                        {
                            var out = {};
                            out.routetag = vehicle[0].getAttribute('routeTag');
                            out.parseddata = [];
                            for ( var v_c =0 ;v_c<vehicle.length ;v_c++)
                            {
                                var attr = {};
                                attr.id = vehicle[v_c].getAttribute('id');
                                var lat = vehicle[v_c].getAttribute('lat');
                                var lon = vehicle[v_c].getAttribute('lon');
                                var index = old_present ? vehicle_old.findIndex(x=>x.id==attr.id) : -1;
                                attr.x = projection([lon,lat])[0];
                                attr.y = projection([lon,lat])[1];
                                attr.c_heading = vehicle[v_c].getAttribute('heading');
                                attr.old_x = old_present ? vehicle_old[index].x : attr.x;
                                attr.old_y = old_present ? vehicle_old[index].y : attr.y;
                                attr.old_heading = old_present ? vehicle_old[index].heading : attr.c_heading;  
                                out.parseddata.push(attr);        
                            }
                            return(out);
                        }
                        else
                        {
                            return(0);
                        }
                        }
                    else 
                        {
                        return(0);    
                        }
                    }

/***************************  Functions ***************************/

/***************************  Directive muniLocation Starts ***************************/
sfmuniapp.directive('muniLocation',function(){
	
 	return{
    		restrict :'E',
    		scope:
    		{
    			projection : '=',
    			vehicledata : '=',
                mapsvg :'=',
                vehicletag:'='
    		},
    		link:function(scope,element,attrs)
    		{

    			scope.$watchGroup(['projection','vehicledata','mapsvg','vehicletag'],function(newData,oldData){

                    var projection = newData[0];
    				var vehicle_old = oldData[1];
                    var vehicle_current = newData[1];
                    var vehicletag= newData[3];

                    if(vehicle_current)
                    {
                    var vehicle_update = false;
                    var current_state = vehicle_current.querySelectorAll('vehicle');
                    var parsed_current_data = vehicle_data_parser(vehicle_current,vehicle_old);
                    var map_svg = newData[2];

                    $("#vehicle_locations").remove();
                    var vehicle_locations = map_svg.append("g")
                                            .attr("id","vehicle_locations")
                    
                    var arc = d3.symbol().type(d3.symbolTriangle);

                    vehicle_locations.selectAll("path")
                                        .data(parsed_current_data.parseddata)
                                        .enter()
                                        .append("path")
                                        .attr("d", arc)
                                        .attr("transform", function(d) {
                                                return "translate(" + d.old_x+","+d.old_y+ ") rotate("+d.old_heading+") scale(1.5,2.0)";
                                            })
                                        .attr("fill","black")
                                        .attr("opacity",0.4)
                                        .on("mouseover",function(d){
                                            d3.select(this).attr("fill","white")
                                            d3.select(this).attr("opacity","1.0")
                                            show_id(d);
                                        })
                                        .on("mouseout",function(){
                                            d3.select(this).attr("fill","black")
                                            d3.select(this).attr("opacity","0.4")
                                            remove_id();
                                        })
                                        .transition()
                                        .duration(4000)
                                        .ease(d3.easeLinear)
                                        .attr("transform", function(d) {
                                                return "translate(" + d.x+","+d.y+ ") rotate("+d.c_heading+") scale(1.5,2.0)";
                                            })
                                        
                    }


                     function show_id(d)
                     {
                        vehicle_locations.append("text")
                                        .text(parsed_current_data.routetag+"-"+d.id)
                                        .attr("font-size",'15px')
                                        .attr("id","id_text")
                                        .attr("x",d.x)
                                        .attr("y",d.y);
                     } 
                     function remove_id()
                     {
                        $('#id_text').remove();
                     }                
                    
                     })
    			}
    		}
    	});

/***************************  Directive muniLocation Ends ***************************/
