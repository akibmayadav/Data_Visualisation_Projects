var sfmuniapp = angular.module('sfMap',[]);

/***************************  Controller Starts ***************************/
sfmuniapp.controller('sfMapController',function sfMapController($q,$scope,$http,$element){

	
	$scope.projection = null;
	$scope.current_time =null;
	$scope.vehicledata=null;
	$scope.allroutes=null;
	$scope.model = {};
	$scope.model.vehicletag="L";
	$scope.vehicletag=$scope.model.vehicletag;
	
	d3.json('assets/data/sfmaps/neighborhoods.json',function(err,data){
					var width = 2*window.innerWidth/3;
					var height = window.innerHeight;
					var margin = 40;
					projection = d3.geoAlbersUsa() 
				   			.fitExtent([[margin,margin],[width-margin,height-margin]],data)
					$scope.$apply(function(){
						$scope.projection = projection;
					});

			});

	d3.csv('assets/data/sfmuni/route.csv',function(data)
			{
					$scope.allroutes=data;
			});

	// Setting Up Current Clock
	setInterval(function(){
		var d = new Date();
		$scope.current_time = d.getHours()+':'+d.getMinutes()+':'+d.getSeconds();
		$scope.vehicletag=$scope.model.vehicletag;
		$scope.$apply();
	},500);

	
	// Getting Vehicle Data
	$scope.callcurrentapi=function()
	{
	var cur_loc_url = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r="+$scope.model.vehicletag+"&t=0";
	$.ajax({
        crossOrigin: true,
        url: cur_loc_url,
        success: function(data) {
            $scope.vehicledata=data;
			$scope.$apply();
	}
	})
	}

	$scope.callcurrentapi();
	setInterval(function(){
		$scope.callcurrentapi();
	},4000)


	var width = 2*window.innerWidth/3;
	var height = window.innerHeight-30;
	var margin = 20;
	
	$scope.mapsvg = d3.select($element[0])
					.append("div")
					.attr("class","Main_Map_bg")
					.append("svg")
					.attr('width',width)
					.attr('height',height)

					
});

/***************************  Controller Ends ***************************/