#clean up all files in the derived subdirectory as they will be generated again now
echo 'Cleaning up old derived files (mastersheets and lokdhaba files).....'
find ../ -name 'derived' | xargs -I{} rm -rf {}
echo 'Cleaning up done...'

#create derived folder for each state directory again
ls -d ../Data/* | xargs -I{} mkdir {}/derived

#create mastersheet.csv file for each state
echo '-------------------------Generating mastersheets for all states in
assembly elections-----------------------------'
ls -d ../Data/* | xargs -I{} Rscript Derived_Var_Addition.R {} ../VidhaSabhaNumber.csv ../../Delim.csv 
echo '-------------------------Done generating
mastersheets-----------------------------------'

#create lokdhaba directory from the mastersheet files
echo '-------------------------Generating lokdhaba files for all
states-----------------------------------------'
ls -d ../Data/* | xargs -I{} Rscript lokdhaba.R {}
echo '-------------------------Done generating lokdhaba
files------------------------------------------'
