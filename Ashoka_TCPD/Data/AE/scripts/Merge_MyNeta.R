library(plyr)
library(gdata)
library(data.table)
library(plyr)
source("helper.R")
args = commandArgs(TRUE)
if (length(args) != 1)  {

    stop ("Please provide 1 argument:  subdirectory of  state
          folder for which you want to create this merged file")
}

#open the derived file present in args[1]/derived/mastersheet.csv -- give error if not found and stop
#open acname_keys.csv and myneta.csv files present in args[1]/primary/myneta/  -- give error if not found and stop
#open partyname_keys.csv present in args[1]/primary/myneta/  -- give error if not found and stop
#remove all the data from myneta.csv where party is IND
#merge derived file with acname_keys.csv based on (Year, AC_Name) and (Year,ec_ac_Name) columns it will add a  mn_ac_Name
#merege this combined frame with file partyname_keys.csv on year and ec_Party_Name column it will add mn_Party_Name column in it
#merge this combined file with myneta.csv on (year,mn_ac_Name column,mn_Party_Name) columns  and (conName,Party_Code) column, before that remove all information like actype, cand name etc from myneta file

infile<-read.csv(paste0(args[1],"/derived/mastersheet.csv"),stringsAsFactors=FALSE)
mynetakey<-read.csv(paste0(args[1],"/primary/myneta/acname_keys.csv"),stringsAsFactors=FALSE)
myneta<-read.csv(paste0(args[1],"/primary/myneta/myneta.csv"),stringsAsFactors=FALSE)

partymap<-read.csv(paste(args[1],"primary/myneta/partyname_keys.csv",sep="/"),stringsAsFactors=FALSE)


#canonicalize ac name in the mastersheet 
infile$canACName<-canonicalizeACNames(infile$AC_Name)
in_plus_key<-merge(infile,mynetakey,by.x=c("Year","canACName"),by.y=c("Year","ec_AC_Name"),all.x=TRUE)
#at this pint in_plus_key contains a column called mn_AC_Name


##canonicalizing the party name in the eci data  
in_plus_key$canPartyName<-canonicalizePartyNames(in_plus_key$Party1)

#########now merge in_plus_key with myneta_party_map on year and Party1 with year and eci_party
tmp<-merge(in_plus_key,partymap,by.x=c("Year","canPartyName"),by.y=c("Year","ec_Party_Name"),all.x=TRUE)
in_plus_key<-tmp
##at this point in_plus_key also contains a column called mn_Party_Name
#Get info on Non independent candidates
mndata<-subset(myneta,myneta$Party_Code!="IND")

mndata$State_Name<-NULL
#canonicalize con name and party names of myneta data bvecause maps (keys) were created after canonicalizing them
mndata$conName<-canonicalizeACNames(mndata$conName)
mndata$Party_Code<-canonicalizePartyNames(mndata$Party_Code)

in_plus_key_plus_data<-merge(in_plus_key,mndata,by.x=c("Year","mn_AC_Name","mn_Party_Name"),by.y=c("Year","conName","Party_Code"),all.x=TRUE)

#Printing the info about how many merging were done properly
#print(subset(in_plus_key_plus_data,in_plus_key_plus_data$Year>=2008 & in_plus_key_plus_data$mn_party=="LJP"))
doneset<-(subset(in_plus_key_plus_data,!is.na(in_plus_key_plus_data$ac)))
donecount<-nrow(unique(doneset))
print(paste("Filled data for candidates: ",donecount))
print(paste("Total data was available  for candidates ",nrow(mndata)))
####################################################################################

in_plus_key_plus_data$Name<-NULL
in_plus_key_plus_data$Gender<-NULL
in_plus_key_plus_data$Age<-NULL
in_plus_key_plus_data$ac<-NULL
in_plus_key_plus_data$canACName<-NULL
in_plus_key_plus_data$canPartyName<-NULL
in_plus_key_plus_data$mn_AC_Name<-NULL
in_plus_key_plus_data$mn_Party_Name<-NULL

#print(names(in_plus_key_plus_data))

write.csv(in_plus_key_plus_data,paste0(args[1],"/derived/mastersheet_myneta.csv"),row.names=FALSE)



