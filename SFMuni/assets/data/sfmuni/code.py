import urllib2

base_url="http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni&r="


routes = ["1", "1AX", "1BX", "2", "3", "5", "5R", "6", "7R", "7X", "8", "8AX", "8BX", "9", "9R", "10", "12", "14","14R","14X","18","19","21","22","23","24","25","27","28","28R","30","30X","31","31AX","31BX","33","35","36","37","38","38AX","38BX","39","41","43","44","45","47","48","49","52","54","55","56","57","66","67","76X","81X","82X","83X","88","90","91","K_OWL","L_OWL","M_OWL","N_OWL","T_OWL","59","60","61"]

for route in routes:
	content = urllib2.urlopen(base_url+route).read()
	file_name = "muni_"+route+".xml"
	with open(file_name, "w") as text_file:
	    text_file.write(content)
	print route+" done"
