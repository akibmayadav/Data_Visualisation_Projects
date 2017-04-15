// PART 2 Drawing the Treemap Using Three.js 

function draw_treemap(root,current_year)
    {
 /*** Drawing the Treemap Using Three.js ***/
    var camera, controls,scene,renderer;
    var play_mode = false;
    var frame =0;
    var year_animation = 1955 ;
    var start_h = new Array();
    var end_h =new Array();
    var final_h = new Array();
    var final_c = new Array();

    // Add a spotlight 
 	var max_h = 600;
	var min_h = 10; 

	var total_x = -500; 
	var total_y = -270;

	var populations = [];

	
	// Loading populations values in object array . 
	for ( var r_c = 0; r_c <root.children.length ; r_c++)
	{
		var p =[]; // convert to an array 
		p[0] = parseInt(root.children[r_c].data.p_1950);
		p[1] = parseInt(root.children[r_c].data.p_1955);
		p[2] = parseInt(root.children[r_c].data.p_1960);
		p[3] = parseInt(root.children[r_c].data.p_1965);
		p[4] = parseInt(root.children[r_c].data.p_1970);
		p[5] = parseInt(root.children[r_c].data.p_1975);
		p[6] = parseInt(root.children[r_c].data.p_1980);
		p[7] = parseInt(root.children[r_c].data.p_1985);
		p[8] = parseInt(root.children[r_c].data.p_1990);
		p[9] = parseInt(root.children[r_c].data.p_1995);
		p[10] = parseInt(root.children[r_c].data.p_2000);
		p[11] = parseInt(root.children[r_c].data.p_2005);
		p[12] = parseInt(root.children[r_c].data.p_2010);
		p[13] = parseInt(root.children[r_c].data.p_2015);
		populations.push(p);

	}

	// Finding maximum of population differences from 2015
	var max_p =0;
	for ( var r_c = 0; r_c <root.children.length ; r_c++)
	{
		for ( var y_c = 1 ; y_c<14 ;y_c++)

		{
			var population_change = populations[r_c][y_c] - populations[r_c][y_c-1];
			if (max_p < population_change)
			{
				max_p = population_change;
			}
		}
	} 

	// Finding minimum of populations from 1950
	var min_p =max_p; 
	for ( var r_c = 0; r_c <root.children.length ; r_c++)
	{
		for ( var y_c = 1 ; y_c<14 ;y_c++)
		{
			var population_change = populations[r_c][y_c] - populations[r_c][y_c-1];
			if(min_p > population_change)
			{
			min_p = population_change;
			}
		}
	}

	var start_year = 1950;
	function cou_hie_col(current_y,r_c)
	{
	var year_diff = 5; 
	var country_name = root.children[r_c].data.Countries;
	var n_years = populations[r_c].length ;
	var z = [];
	z[0] = 0; 
	var z_padding = 10 ;  
	
	// Finding the height for every country . 
	var year_index = (current_y - start_year)/year_diff ;
	// Wrong Mapping in terms of data visualization . The lie factor is will be too much . Ask Karl. Maybe. 
	var unmapped_height = populations[r_c][year_index]-populations[r_c][year_index-1];
	var height = convertToRange(Math.abs(unmapped_height),[min_p,max_p],[min_h,max_h]) ;

	var hue,sat,lit,final_h;
	// Color Mapping of Every Country . 
	if(unmapped_height >= 0)
	{
	hue = 53/360; 
	sat = convertToRange(unmapped_height,[0,max_p],[0.2,1.0]) ;
	lit = 0.4;
	final_h = height/2;
	}

	else if(unmapped_height< 0)
	{
	hue = 10/360; 
	sat = convertToRange(unmapped_height,[min_p,0],[1.0,0.2]) ;
	lit = 0.4;
	final_h = -1*height/2;
	}

	var color_broof = new THREE.Color();
	color_broof.setHSL(hue,sat,lit);

	var final_par = new Object();
	final_par.final_h = final_h;
	final_par.color_broof = color_broof;
	final_par.hue = hue;
	final_par.sat = sat; 
	return final_par;
 	}
	

	function add_cube_scene(h,col,r_c)
	{
	 var x = root.children[r_c].x0 ; 
	 var y = root.children[r_c].y0 ;
	 var l = root.children[r_c].x1 - x ; 
	 var b = root.children[r_c].y1 - y ;
	 var geometry = new THREE.BoxGeometry( l,b,Math.abs(2*h));
	 var material = new THREE.MeshLambertMaterial( {color : col});
	 var cube = new THREE.Mesh( geometry, material );
	 cube.position.x = x + l/2 + total_x;
	 cube.position.y = y + b/2 + total_y; 
	 cube.position.z = h; 
	 cube.name = root.children[r_c].data.Countries;
	 scene.add( cube );	
	}

    init();
    animate();

    function init()
    {
    // First need to place an interactive camera in place. 
	// camera = new THREE.PerspectiveCamera( 180, width / height, -200, 10000 );
	camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, - 500, 1000 );
				// To resolve gimbal lock to look around city . Change the plane of mapping . Make it the x,z plane instead of x,y.
				camera.position.z = 200;

	controls = new THREE.OrbitControls(camera);
	controls.addEventListener('change',render);

	scene = new THREE.Scene();
    scene.background = background_color_for_three;

	var spotLight_back = new THREE.SpotLight( 0xffffff,2.0,3000,Math.PI);
	spotLight_back.position.set( 0,0, max_h +300 );
	spotLight_back.castShadow = true;

	scene.add( spotLight_back );

	var spotLight_front = new THREE.SpotLight( 0xffffff,2.0,3000,Math.PI);
	spotLight_front.position.set( 100, -600, 100 );
	spotLight_front.castShadow = true;

	scene.add( spotLight_front );

	var spotLight_back = new THREE.SpotLight( 0xffffff,2.0,3000,Math.PI);
	spotLight_back.position.set( 100, 600, 100 );
	spotLight_back.castShadow = true;

	scene.add( spotLight_back );

	for ( var r_c = 0; r_c <root.children.length ; r_c++)
	{
 	var final_para = cou_hie_col(current_year,r_c);
	add_cube_scene(final_para.final_h,final_para.color_broof,r_c);
	}

	// renderer = new THREE.WebGLRenderer();
	// renderer.setSize( width_tree,height_tree);
	// container.appendChild( renderer.domElement );
	renderer = new THREE.WebGLRenderer({ antialias : false});
	renderer.setSize( window.innerWidth, window.innerHeight );
	document.body.appendChild( renderer.domElement );
	window.addEventListener('resize',onWindowResize, false);
	
	// Adding Key Based Interaction
	
	function handleKeyDown(event) 
	{

  	if (event.keyCode === 13) 
  		{ 
  			console.log("play");
    		play_mode = true;
    		frame = 0 ;
    		year_index_animation = 1955 ;
  		}
  	else
  		{
  			console.log("stop");
  			play_mode=false;
  		}
	}
	window.addEventListener('keydown', handleKeyDown, false);
	
	} //init ends here 

	function onWindowResize()
	{
		camera.aspect = window.innerWidth/window.innerHeight;
		// camera.aspect = width_tree/height_tree;
		camera.updateProjectionMatrix();
		renderer.setSize(window.innerWidth,window.innerHeight);
		render();
	}

	function animate() 
	{
  	requestAnimationFrame( animate );
  	if (play_mode) 
  	{
  		frame+=1;
  		var t_s = 120;
  		if(frame<13*t_s) // limiting animation to 12 seconds. 1 for each year.
  		{	
  			if(frame%t_s == 0)
  			{
  			year_index_animation += 5;
  			start_h_i = year_index_animation -5;
  			end_h_i = year_index_animation;
  			for ( var a = 0 ; a < root.children.length ;a++)
  			{
  				start_h[a] = cou_hie_col(start_h_i,a);
  				end_h[a] = cou_hie_col(end_h_i,a); 
  			}  			
  		 	var but_id = "b_"+start_h_i;
  		 	$("#" + but_id).css("background-color","#FF5533");
  			if (end_h_i == 2015)
  			{
  		 		$("#b_2015").css("background-color","#FF5533");
  			}
  			console.log(year_index_animation,start_h[1],end_h[1]);
  			}

  			if(frame >t_s)
  			{
  				for(var a = 0 ; a <root.children.length ; a++)
  				{
  					// var count = (frame%t_s>0) ? frame%t_s : 60;
  					var count = frame%t_s;
  					final_h[a] = start_h[a].final_h + (end_h[a].final_h-start_h[a].final_h)*count/t_s;
  					var sc = final_h[a]/start_h[a].final_h;
					var hue_s = (final_h[a]>=0) ? 53/360 : 10/360;
  					var sat_s = start_h[a].sat + (end_h[a].sat-start_h[a].sat)*(frame%60)/60;
  					// scene.children[a+3].geometry.verticesNeedUpdate=true;
  					scene.children[a+3].position.z = final_h[a];
  					// scene.children[a+3].scale.z = sc;
  					// scene.children[a+3].geometry.parameters.height=Math.abs(2*final_h[a]);
  					scene.children[a+3].material.color.setHSL(hue_s,sat_s,0.4);
  				}
  				console.log(final_h[1]);


  			}
  		}
  		controls.update();
  		render();
  	}
	}

	function render() 
	{
  	renderer.render( scene, camera );
	}

	render();
	console.log(scene);
	console.log(scene.children[3].position.z);
	console.log(scene.children[3].geometry.parameters.height);
}