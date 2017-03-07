chloropeth_index();
function chloropeth_index()
{
var chloropeth_map_index = map_area.append("g").attr("id","index");
	// no data
	chloropeth_map_index.append("rect")
						.attr("x",2*padding)
						.attr("y",map_area_height -map_y-2*padding-map_area_height/10)
						.attr("width",20)
						.attr("height",20);

	chloropeth_map_index.append("text")
						.attr("x",2*padding + 30)
						.attr("y",map_area_height -map_y-2*padding+15-map_area_height/10)
						.attr("width",20)
						.attr("height",20)
						.attr('class','index_font')
						.attr("font-size",10)
						.text ("No Data from Here")
	//min
	chloropeth_map_index.append("rect")
						.attr("x",2*padding)
						.attr("y",map_area_height -map_y-2*padding-map_area_height/10 +30)
						.attr("width",20)
						.attr("height",20)
						.attr("fill","#c70039")
						.attr("opacity",0.2);

	chloropeth_map_index.append("text")
						.attr("x",2*padding + 30)
						.attr("y",map_area_height -map_y-2*padding+15-map_area_height/10 +30)
						.attr("width",20)
						.attr("height",20)
						.attr('class','index_font')
						.attr("font-size",10)
						.text ("Minimum KOL Density")
	//max
	chloropeth_map_index.append("rect")
						.attr("x",2*padding)
						.attr("y",map_area_height -map_y-2*padding-map_area_height/10 +60)
						.attr("width",20)
						.attr("height",20)
						.attr("fill","#c70039")
						.attr("opacity",0.9);

	chloropeth_map_index.append("text")
						.attr("x",2*padding + 30)
						.attr("y",map_area_height -map_y-2*padding+15-map_area_height/10 +60)
						.attr("width",20)
						.attr("height",20)
						.attr('class','index_font')
						.attr("font-size",10)
						.text ("Maximum KOL Density");
}
//Index 

var responder_area_index = responder_cat_bar_area.append("g")

responder_area_index.append("rect")
						.attr("x",0)
						.attr("y",responders_area_bg_height - 70)
						.attr("width",responders_area_bg_width)
						.attr("fill","white")
						.attr("height",1);

responder_area_index.append("text")
						.attr("x",responders_area_bg_width/2)
						.attr("y",responders_area_bg_height - 45)
						.attr("class","index_font")
						.attr("font-size",15)
						.attr("text-anchor","middle")
						.text("RESPONDERS CATEGORY COUNT / STATE");

responder_area_index.append("rect")
						.attr("x",20)
						.attr("y",responders_area_bg_height - 30)
						.attr("width",20)
						.attr("fill","#900C3F")
						.attr("height",20);

responder_area_index.append("text")
						.attr("x",50)
						.attr("y",responders_area_bg_height - 15)
						.attr("class","index_font")
						.attr("font-size",12)
						.text("Has patient(s)");

responder_area_index.append("rect")
						.attr("x",responders_area_bg_width/2 -110)
						.attr("y",responders_area_bg_height - 30)
						.attr("fill","#C70039")
						.attr("width",20)
						.attr("height",20);

responder_area_index.append("text")
						.attr("x",responders_area_bg_width/2 -80)
						.attr("y",responders_area_bg_height - 15)
						.attr("class","index_font")
						.attr("font-size",12)
						.text("Highly Experienced Specialist");

responder_area_index.append("rect")
						.attr("x",responders_area_bg_width -150)
						.attr("y",responders_area_bg_height - 30)
						.attr("fill","#FF5733")
						.attr("width",20)
						.attr("height",20);

responder_area_index.append("text")
						.attr("x",responders_area_bg_width -120)
						.attr("y",responders_area_bg_height - 15)
						.attr("class","index_font")
						.attr("font-size",12)
						.text("No current patients");
