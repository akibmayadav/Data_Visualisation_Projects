import csv  
import json  
  
# Open the CSV  

#open files and handle header

#Subsampling Data
def csvtorecsv(inputfile):
	inp = '/Users/akibmayadav/Documents/Personal_Webapge_Development/Processing_Code_Porting/Code_Of_Red/Data_Parsing_Into_JSON/Raw_csv/' + inputfile;
	oup = '/Users/akibmayadav/Documents/Personal_Webapge_Development/Processing_Code_Porting/Code_Of_Red/Data_Parsing_Into_JSON/Processed_Csv/1_' + inputfile ;
	f = open( inp, 'rU' )  
	f_out = open( oup , 'w' )    
	reader = csv.DictReader( f, fieldnames = ( "art_origin" ,"artist_name" ,"art_name" ,"year"))
	writer = csv.DictWriter( f_out, fieldnames = ("art_origin" ,"artist_name" ,"art_name" ,"year"))
	count = 0
	for row in reader:
		count = count +1
		if (count%1 == 0) :
			writer.writerow(row)

# Conversion
def recsvtojson(inputfile):
	oup = '/Users/akibmayadav/Documents/Personal_Webapge_Development/Processing_Code_Porting/Code_Of_Red/Data_Parsing_Into_JSON/Processed_Csv/1_' + inputfile ;
	f_out2 = open( oup , 'rU' )
	reader2 = csv.DictReader( f_out2, fieldnames = ( "art_origin" ,"artist_name" ,"art_name" ,"year"))
	out_name = inputfile[:-4];
	out = "var Worldwide_Artwork"+"= [\n\t" + ",\n\t".join([json.dumps(row) for row in reader2]) + "\n]"

	print "JSON parsed!"  
	# Save the JSON  
	out_n = '/Users/akibmayadav/Documents/Personal_Webapge_Development/Processing_Code_Porting/Code_Of_Red/Data_Parsing_Into_JSON/Json/'+out_name+".js"
	f = open( out_n, 'w')  
	f.write(out)  
	print "JSON saved!"  

csvtorecsv("Worldwide_Artwork.csv")
recsvtojson("Worldwide_Artwork.csv")



