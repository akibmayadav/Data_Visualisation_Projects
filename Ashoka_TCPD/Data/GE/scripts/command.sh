#clean up all files in the derived subdirectory as they will be generated again now
echo '-------------Cleaning up old derived files --------'
rm -rf Data/derived
echo '-------------Done cleaning up ---------------------'

#create mastersheet.csv 
echo '-------------Generating mastersheet for general assembly
elections------------------------------------------------'
Rscript Derived_Var_Addition.R ../Data ../LokSabhaNumber.csv ../../Delim.csv 
echo '-------------Done generating
masterhseet----------------------------------------------'

#create lokdhaba directory from the mastersheet files
echo '--------------Generating lokdhaba files for general assembly elections
----------------------------------------------------------'
Rscript lokdhaba.R ../Data 
echo '--------------Done generating lokdhaba
files------------------------------------------------------'
